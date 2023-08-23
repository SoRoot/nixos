{
  description = "My machines";

  inputs = {
    # Add other inputs as needed
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    # Home-manager
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    waveforms.url = "github:soroot/waveforms-flake";
    waveforms.inputs.nixpkgs.follows = "nixpkgs";

    paymo-track-appimage = {
      url = "https://track-paymoapp-com.s3-accelerate.amazonaws.com/paymo-track-linux-x86_64-8.9.6.AppImage";
      flake = false;
    };

    prospect-mail-appimage = {
      url = "https://github.com/julian-alarcon/prospect-mail/releases/download/v0.4.0/Prospect-Mail-0.4.0.AppImage";
      flake = false;
    };

  };

  outputs = { self, nixpkgs, waveforms, home-manager, prospect-mail-appimage, paymo-track-appimage, ... }:
    {
      # Use nixpkgs-fmt for 'nix fmt'
      formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.nixpkgs-fmt;

      # A Nixpkgs overlay.
      overlays.default = final: prev:
        with prev.pkgs; {
          paymo-track = appimageTools.wrapType2 # or wrapType1
            {
              name = "paymo-track";
              src = paymo-track-appimage;
            };
          prospect-mail = appimageTools.wrapType2
            {
              name = "prospect-mail";
              src = prospect-mail-appimage;
            };
        };

      # NixOS hosts. Apply with:
      # nixos-rebuild switch --flake '.#nixos-wdno'                   # Inside this repository, or
      # nixos-rebuild switch --flake '/path/to/this/repo#nixos-wdno'  # From anywhere else
      nixosConfigurations = {

        # Currently only one host. Add others here when needed.
        nixos-wdno = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            ./configuration.nix
            home-manager.nixosModules.home-manager
            waveforms.nixosModule
            ({
              users.users.lukas.extraGroups = [ "plugdev" ];
              nixpkgs.overlays = [ self.overlays.default ];
            })
          ];
        };
      };
    };
}
