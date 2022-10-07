{
  description = "An example NixOS configuration";

  inputs = {
    nixpkgs = { url = "github:nixos/nixpkgs/nixos-unstable"; };
    nixpkgs-github-runner = { url = "github:codedownio/nixpkgs/multiple-github-runners"; };
  };

  outputs = inputs: {
    nixosConfigurations = rec {
      containers.github-runner = inputs.nixpkgs-github-runner.lib.nixosSystem  {
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
          github-runner = containers.github-runner;
        };
      };
    };
  };
}

