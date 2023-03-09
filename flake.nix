{
  description = "My machines";

  inputs = {
    # Add other inputs as needed
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    waveforms.url = "github:liff/waveforms-flake";
  };

  outputs = { self, nixpkgs, waveforms, ... }:
    {

      # Use nixpkgs-fmt for 'nix fmt'
      formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.nixpkgs-fmt;

      # NixOS hosts. Apply with:
      # nixos-rebuild switch --flake '.#nixos-wdno'                   # Inside this repository, or
      # nixos-rebuild switch --flake '/path/to/this/repo#nixos-wdno'  # From anywhere else
      nixosConfigurations = {

        # Currently only one host. Add others here when needed.
        nixos-wdno = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            ./configuration.nix
            waveforms.nixosModule
            ({ users.users.lukas.extraGroups = [ "plugdev" ]; })
          ];

        };
      };
    };
}
