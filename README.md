## Install log

1. connected to vps via ssh when it's in recovery mode
2. installed nix
  ```
  sh <(curl -L https://nixos.org/nix/install) --daemon
  # exit and relogin to activate nix
  nix-env -i nixos-install-tools
  ```
3. install nixos using https://nixos.org/manual/nixos/stable/index.html#ch-installation
  ```
  parted /dev/sda -- mklabel msdos
  parted /dev/sda -- mkpart primary 1MB -8GB
  parted /dev/sda -- mkpart primary linux-swap -8GB 100%

  mkfs.btrfs -L nixos -f /dev/sda1
  mkswap -L swap /dev/sda2
  mount /dev/disk/by-label/nixos /mnt
  mkdir -p /mnt/boot
  swapon /dev/sda2
  nixos-generate-config --root /mnt
  # convert the config into a flake according to https://github.com/colemickens/nixos-flake-example
  curl https://raw.githubusercontent.com/colemickens/nixos-flake-example/master/flake.nix > /mnt/etc/nixos/flake.nix
  cd /mnt/etc/nixos/

  # edit the config file accordingly
  vim configuration.nix

  unset NIX_PATH
  nixos-install --flake ".#mysystem"
  ```

## Commands

### Update and Rebuild

```
nix flake update && nixos-rebuild --flake .#host --target-host root@${IP:?} switch
```
