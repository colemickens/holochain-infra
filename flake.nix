{
  description = "An example NixOS configuration";

  inputs = {
    nixpkgs = { url = "github:nixos/nixpkgs/nixos-unstable"; };
    nixpkgs-github-runner = { url = "github:codedownio/nixpkgs/multiple-github-runners-oct3"; };
  };

  outputs = inputs: {
    __cfg = ({ pkgs, ... }: {
      imports = [
        ./nixos-containers/github-runner/configuration.nix
      ];
    });
    nixosConfigurations = rec {
      github-runner-container = inputs.nixpkgs-github-runner.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./nixos-containers/github-runner/configuration.nix
        ];
      };

      github-runner-host = inputs.nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./nixos-hosts/github-runner-host/configuration.nix
        ];

        specialArgs = {
          inherit inputs;
        };
      };
    };
  };
}

