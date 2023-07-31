# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, ... }:

{
  imports =
    [
      # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

 # # Use the GRUB EFI boot loader.
 # boot.loader.grub.enable = true;
 # # Define on which hard drive you want to install Grub.
 # boot.loader.grub.device = "nodev";
 # boot.loader.grub.efiSupport = true;
 # boot.loader.grub.useOSProber = true;
 # boot.loader.grub.efiInstallAsRemovable = true;
 # boot.loader.grub.extraEntries = ''
 #   menuentry "Windows 11" {
 #     chainloader (hd0,2)+1
 #   }
 # '';
  #boot.loader.efi.efiSysMountPoint = "/boot/efi";
  #boot.loader.efi.canTouchEfiVariables = true; #
  boot.loader.systemd-boot.enable = true;

  networking.hostName = "nixos-wdno"; # Define your hostname.
  # Pick only one of the below networking options.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager = { # Easiest to use and most distros use this by default.
    enable = true;
    #wifi.powersave = false; # Powersave true can make ssh connections slow
  };
  

  # Workaround from error discussed https://github.com/NixOS/nixpkgs/issues/180175
  systemd.services.NetworkManager-wait-online.enable = lib.mkForce false;
  systemd.services.systemd-networkd-wait-online.enable = lib.mkForce false;

  # systemd paymo-widget service
  systemd.user.services."paymo-widget" = {
    description = "Paymo widget";
    wantedBy = [ "graphical-session.target" ];
    partOf = [ "graphical-session.target" ];
    serviceConfig = {
      Restart = "on-failure";
      RestartSec = 5;
      ExecStart = "${pkgs.paymo-widget}/bin/paymo-widget";

    };
  };

  # systemd Prospect-Mail service
  systemd.user.services."prospect-mail" = {
    description = "Prospect Mail";
    wantedBy = [ "graphical-session.target" ];
    partOf = [ "graphical-session.target" ];
    serviceConfig = {
      Restart = "on-failure";
      RestartSec = 5;
      ExecStart = "${pkgs.prospect-mail}/bin/prospect-mail";
    };
  };

  # systemd OneDrive service
  services.onedrive.enable = true;

  # Set your time zone.
  time.timeZone = "America/Mexico_City";

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    useXkbConfig = true; # use xkbOptions in tty.
  };

  nix = {

    # Enable flakes
    settings.experimental-features = [ "nix-command" "flakes" ];

    # Enables storage optimization via hardlinking store files
    settings.auto-optimise-store = true;

    # Garbage Collector - Clean up old generations after 30 days
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 30d";
    };
  };

  # Enable the X11 windowing system.
  services.xserver = {
    enable = true;
    desktopManager = {
      xterm.enable = false;
      xfce.enable = true;
    };
    displayManager.defaultSession = "xfce";
  };

  # Configure keymap in X11
  services.xserver.layout = "us,es,de";
  services.xserver.xkbOptions = "caps:escape"; # map caps to escape.

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = true;

  # Enable Bluetooth
  hardware.bluetooth.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  services.xserver.libinput.enable = true;

  # Enable home-manager
  home-manager.useUserPackages = true;
  home-manager.users.lukas = import ./home.nix;

  programs.zsh.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.lukas = {
    isNormalUser = true;
    extraGroups = [
      "wheel" # Enable ‘sudo’ for the user.
      "networkmanager" # Permission to chenge network settings
    ];
    shell = pkgs.zsh;
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment = {
    sessionVariables = {
      NIXOS_OZONE_WL = "1";
      # Set Environment variable
      VISUAL = "nvim";
    };

    # System-wide installed packages. See ./home.nix for user-specific programs
    systemPackages = with pkgs; [
      python311
      wget
      git
      gnumake
      cmake
      binutils
      zeromq
      gcc-arm-embedded
      appimage-run
      dejavu_fonts
      htop
      neovim
      ntfs3g
      segger-jlink
      xpdf
      #xclip
      xsel
      #wl-copy
      #wl-paste
      tree
      file
      unzip
      unrar
      bmap-tools
      paymo-widget
      prospect-mail
      # xfce panel plugins
      xfce.xfce4-xkb-plugin
      xfce.xfce4-weather-plugin
    ];
  };

  nixpkgs.config = {
    # Set allowUnfree globally
    allowUnfree = true;
    # accept Linceses for segger-jlink
    segger-jlink.acceptLicense = true;
    permittedInsecurePackages = [
      "xpdf-4.04"
    ];
  };

  # Should make screen sharing possiblie in slack
  xdg = {
    portal = {
      enable = true;
      extraPortals = with pkgs; [
        xdg-desktop-portal-wlr
      ];
      #gtkUsePortal = true;
    };
  };

  # Virtualbox settings
  virtualisation.virtualbox.host.enable = true;
  users.extraGroups.vboxusers.members = [ "lukas" ];


  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;
  programs.ssh.startAgent = true;
  services.gnome.gnome-keyring.enable = true;
  security.pam.services.lightdm.enableGnomeKeyring = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.11"; # Did you read the comment?

}
