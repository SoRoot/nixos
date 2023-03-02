{
  description = "My machines";

  inputs = {
    # Add other inputs as needed
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs, ... }:
    {

      # Use nixpkgs-fmt for 'nix fmt'
      formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.nixpkgs-fmt;

      # NixOS hosts. Apply with:
      # nixos-rebuild switch --flake '.#nixos-kiste'                   # Inside this repository, or
      # nixos-rebuild switch --flake '/path/to/this/repo#nixos-kiste'  # From anywhere else
      nixosConfigurations = {

        # Currently only one host. Add others here when needed.
        nixos-kiste = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [ ./configuration.nix ];
        };
      };
    };
}