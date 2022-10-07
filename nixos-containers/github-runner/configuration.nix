{ pkgs
, lib
, inputs
, ...
}: 

{
  boot.isContainer = true;

  # disabledModules = [ "services/continuous-integration/github-runner.nix" ];
  imports = [
    # inputs.nixos-fhs-compat.nixosModules.combined 
    # "${inputs.nixpkgs-ghrunner}/nixos/modules/services/continuous-integration/github-runner.nix"
    # "${inputs.nixpkgs-ghrunner}/nixos/modules/services/continuous-integration/github-runners.nix"
  ];

  nix.settings.trusted-users = [
    "root"
    "github-runner"
  ];
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  services.github-runners = {
    runner0 = {
      enable = false;
      replace = true;
      ephemeral = true;
      user = "github-runner";
      url = "https://github.com/holochain/holochain";
      tokenFile = "/var/secrets/github-runner/runner0.token";
      package = pkgs.github-runner.overrideAttrs (
        { postInstall ? "", buildInputs ? [], ... }:
        {
          postInstall = postInstall + ''
            ln -s ${pkgs.nodejs-14_x} $out/externals/node12
          '';
        }
      );
      extraPackages = with pkgs; [
        cachix
        tmux
        tmate
        xz
        zstd
        openssh
      ] ++ 
        (builtins.map
        (elem: writeShellScriptBin "${elem}" "echo wanted to run: ${elem} \${@}")
        ["sudo" "apt-get" "apt"]
       );

      serviceOverrides = {
        ProtectHome = false; # Allow the test user to access their home folder
        # CapabilityBoundingSet = "CAP_SYS_ADMIN";
        # RestrictSUIDSGID = false;
      };
    };
  };

  # # Activation scripts for impure set up of paths in /
  system.activationScripts.bin = ''
    echo "setting up /bin..."
    mkdir -p /bin
    ln -sfT ${pkgs.bash}/bin/bash /bin/.bash
    mv -Tf /bin/.bash /bin/bash
  '';
  system.activationScripts.lib64 = ''
    echo "setting up /lib64..."
    mkdir -p /lib64
    ln -sfT ${pkgs.glibc}/lib/ld-linux-x86-64.so.2 /lib64/.ld-linux-x86-64.so.2
    mv -Tf /lib64/.ld-linux-x86-64.so.2 /lib64/ld-linux-x86-64.so.2
  '';

  # environment.fhs.enable = true;
  # environment.fhs.linkLibs = true;
  # environment.lsb.enable = true;
  # environment.lsb.support32Bit = true;

  system.stateVersion = "22.11";
}
