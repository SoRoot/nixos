{
  description = "My machines";

  inputs = {
    # Add other inputs as needed

    #stable
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    #small-stable
    #nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05-small";
    #unstable
    #nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    # Home-manager
    home-manager.url = "github:nix-community/home-manager/release-25.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, home-manager, ... }:
    {
      # Use nixpkgs-fmt for 'nix fmt'
      formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.nixpkgs-fmt;

      # NixOS hosts. Apply with:
      # nixos-rebuild switch --flake '.#nixos-mb'                   # Inside this repository, or
      # nixos-rebuild switch --flake '/path/to/this/repo#nixos-mb'  # From anywhere else
      nixosConfigurations = {

        # Currently only one host. Add others here when needed.
        nixos-mb = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            ./configuration.nix
            home-manager.nixosModules.home-manager
          ];
        };
      };
    };
}
