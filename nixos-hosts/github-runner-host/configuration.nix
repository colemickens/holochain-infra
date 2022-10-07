# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ pkgs
, lib
, inputs
, ...
}: 

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Use the GRUB 2 boot loader.
  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  boot.loader.grub.device = "/dev/sda"; # or "nodev" for efi only

  networking.hostName = "github-runner-host"; # Define your hostname.

  # Set your time zone.
  # time.timeZone = "Europe/Amsterdam";

  # Select internationalisation properties.
  # i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  #   useXkbConfig = true; # use xkbOptions in tty.
  # };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.dev = {
    isNormalUser = true;
    # extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
    packages = with pkgs; [
      vim
      tmate
      openssh
    ];
    openssh.authorizedKeys.keys = [
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDAIODJoJ7Chi8jPTGmKQ5MlB7+TgNGznreeRW/K34v1ey23/FlnIxP9XyyLkzojKALTfAQYgqzrQV3HDSRwhd1rXB7YLq1/CiVWRJvDMTkJiOCV515eiUJGXu1G8e12d/USPNBMEzMJGvqBCIGYen5OxXkyIHIREfePNi5k337G5z9fiuiggxJl9ty6qZ4XIRgFQj9jAoShixP/+99I7XrGWeFQ1BmLZWzi20SQGKvogYnOszDZFqBAHGFnCFYHaTz2jOXXCtQsa27gr8D2iLRFaxvhB7XMK+VbpDcZGjmfRJ701XxFv15GFnFAV71hTaYqj/Ebpw9Vs02+gUp3+tt"
    ];
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;
  services.openssh.permitRootLogin = "prohibit-password";
  users.users."root".openssh.authorizedKeys.keys = [
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDAIODJoJ7Chi8jPTGmKQ5MlB7+TgNGznreeRW/K34v1ey23/FlnIxP9XyyLkzojKALTfAQYgqzrQV3HDSRwhd1rXB7YLq1/CiVWRJvDMTkJiOCV515eiUJGXu1G8e12d/USPNBMEzMJGvqBCIGYen5OxXkyIHIREfePNi5k337G5z9fiuiggxJl9ty6qZ4XIRgFQj9jAoShixP/+99I7XrGWeFQ1BmLZWzi20SQGKvogYnOszDZFqBAHGFnCFYHaTz2jOXXCtQsa27gr8D2iLRFaxvhB7XMK+VbpDcZGjmfRJ701XxFv15GFnFAV71hTaYqj/Ebpw9Vs02+gUp3+tt"
  ];

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  networking.firewall.enable = true;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  containers = {
    github-runner-container = {
      config = inputs.self.outputs.__cfg;
      nixpkgs = inputs.nixpkgs-github-runner;
    };
  };


  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.11"; # Did you read the comment?
}

