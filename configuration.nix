# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, ... }:

let
  # bash script to let dbus know about important env variables and
  # propagate them to relevent services run at the end of sway config
  # see
  # https://github.com/emersion/xdg-desktop-portal-wlr/wiki/"It-doesn't-work"-Troubleshooting-Checklist
  # note: this is pretty much the same as  /etc/sway/config.d/nixos.conf but also restarts
  # some user services to make sure they have the correct environment variables
  dbus-sway-environment = pkgs.writeTextFile {
    name = "dbus-sway-environment";
    destination = "/bin/dbus-sway-environment";
    executable = true;

    text = ''
      dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP=sway
      systemctl --user stop pipewire pipewire-media-session xdg-desktop-portal xdg-desktop-portal-wlr
      systemctl --user start pipewire pipewire-media-session xdg-desktop-portal xdg-desktop-portal-wlr
    '';
  };

  # currently, there is some friction between sway and gtk:
  # https://github.com/swaywm/sway/wiki/GTK-3-settings-on-Wayland
  # the suggested way to set gtk settings is with gsettings
  # for gsettings to work, we need to tell it where the schemas are
  # using the XDG_DATA_DIR environment variable
  # run at the end of sway config
  configure-gtk = pkgs.writeTextFile {
    name = "configure-gtk";
    destination = "/bin/configure-gtk";
    executable = true;
    text = let
      schema = pkgs.gsettings-desktop-schemas;
      datadir = "${schema}/share/gsettings-schemas/${schema.name}";
    in ''
      export XDG_DATA_DIRS=${datadir}:$XDG_DATA_DIRS
      gnome_schema=org.gnome.desktop.interface
      gsettings set $gnome_schema gtk-theme 'Dracula'
    '';
  };

  in
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
  # iwd iNet wireless daemon
  #networking.wireless.iwd.enable = true;
  #networking.networkmanager.wifi.backend = "iwd";
  networking.networkmanager = { # Easiest to use and most distros use this by default.
  enable = true;
    wifi.powersave = false; # Powersave true can make ssh connections slow
  };


  # Workaround from error discussed https://github.com/NixOS/nixpkgs/issues/180175
  systemd.services.NetworkManager-wait-online.enable = lib.mkForce false;
  systemd.services.systemd-networkd-wait-online.enable = lib.mkForce false;

  # systemd paymo-track service
  #systemd.user.services."paymo-track" = {
    #description = "Paymo track";
    #wantedBy = [ "graphical-session.target" ];
    #partOf = [ "graphical-session.target" ];
    #serviceConfig = {
      #Restart = "on-failure";
      #RestartSec = 5;
      #ExecStart = "${pkgs.paymo-track}/bin/paymo-track";

    #};
  #};

  # systemd Prospect-Mail service
  #systemd.user.services."prospect-mail" = {
    #description = "Prospect Mail";
    #wantedBy = [ "graphical-session.target" ];
    #partOf = [ "graphical-session.target" ];
    #serviceConfig = {
      #Restart = "on-failure";
      #RestartSec = 5;
      #ExecStart = "${pkgs.prospect-mail}/bin/prospect-mail";
    #};
  #};

  # systemd OneDrive service
  services.onedrive.enable = true;

  # Set your time zone.
  time.timeZone = "America/Mexico_City";
  #time.timeZone = "America/Chicago";

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
  #services.xserver = {
    #enable = true;
    #desktopManager = {
      #xterm.enable = false;
      #xfce.enable = true;
    #};
    #displayManager.defaultSession = "xfce";
  #};

  # Configure keymap in X11
  services.xserver.layout = "us,es,de";
  #services.xserver.xkbOptions = "caps:escape"; # map caps to escape.

  #services.xserver.displayManager.gdm.enable = true;
  #services.xserver.desktopManager.gnome.enable = true;

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # pipewire optional
  security.rtkit.enable = true;

  # Enable sound and video handling
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # xdg-desktop-portal works by exposing a series of D-Bus interfaces
  # known as portals under a well-known name
  # (org.freedesktop.portal.Desktop) and object path
  # (/org/freedesktop/portal/desktop).
  # The portal interfaces include APIs for file access, opening URIs,
  # printing and others.
  services.dbus.enable = true;
  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      # To make slack screen-sharing possible
      xdg-desktop-portal-wlr
      # gtk portal needed to make gtk apps happy
      xdg-desktop-portal-gtk
    ];
    #xdgOpenUsePortal = true;
    wlr.enable = true;
  };

  # sway config to render sway
  hardware.opengl.enable = true;

  # Map CapsLock to Esc on single press and Ctrl on when used with multiple keys.
  services.interception-tools = {
    enable = true;
    plugins = [ pkgs.interception-tools-plugins.caps2esc ];
    udevmonConfig = ''
      - JOB: "${pkgs.interception-tools}/bin/intercept -g $DEVNODE | ${pkgs.interception-tools-plugins.caps2esc}/bin/caps2esc | ${pkgs.interception-tools}/bin/uinput -d $DEVNODE"
        DEVICE:
          EVENTS:
            EV_KEY: [KEY_CAPSLOCK, KEY_ESC]
    '';
  };

  # Enable sound.
  sound.enable = true;
  #hardware.pulseaudio.enable = true;

  # Enable Bluetooth
  hardware.bluetooth.enable = true;
  services.blueman.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  services.xserver.libinput.enable = true;

  # Enable home-manager
  home-manager.useUserPackages = true;
  home-manager.users.lukas = import ./home.nix;

  # Enable zsh here and in home.nix is necesary
  programs.zsh.enable = true;

  # Brightness for display
  programs.light.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.lukas = {
    isNormalUser = true;
    extraGroups = [
      "wheel" # Enable ‘sudo’ for the user.
      "networkmanager" # Permission to chenge network settings
      "video"
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
      # Sway
      dbus-sway-environment
      configure-gtk
      wayland
      xdg-utils # for opening default programs when clicking links
      glib # gsettings
      dracula-theme # gtk theme
      gnome3.adwaita-icon-theme  # default gnome cursors
      grim # screenshot functionality
      slurp # screenshot functionality
      wl-clipboard # wl-copy and wl-paste for copy/paste from stdin / stdout
      wofi # wayland clone rofi launcher
      mako # notification system developed by swaywm maintainer
      waybar # status bar
      wdisplays # tool to configure displays
      interception-tools # remap esc to capslock
      playerctl # lib for controlling media


      #python311
      wget
      ripgrep
      ripgrep-all
      fd
      bat
      chafa
      #pandoc
      #poppler_utils
      #ffmpeg
      iperf
      libftdi1
      usbutils
      gnumake
      libgccjit
      gccgo
      cmake
      gdb
      binutils
      zeromq
      appimage-run
      htop
      neovim
      neofetch
      meld
      ntfs3g
      #gcc-arm-embedded
      #segger-jlink
      xpdf
      feh
      #xclip
      #xsel
      tree
      file
      unzip
      zip
      unrar
      p7zip
      bmap-tools
      paymo-track
      prospect-mail
      # xfce panel plugins
      #xfce.xfce4-xkb-plugin
      #xfce.xfce4-weather-plugin
    ];
  };

  fonts = {
    packages = with pkgs; [
      liberation_ttf
      dejavu_fonts
      hack-font
      font-awesome
      noto-fonts
      noto-fonts-cjk
      noto-fonts-emoji
      fira-code
      fira-code-symbols
      mplus-outline-fonts.githubRelease
      dina-font
      proggyfonts
    ];
    fontconfig.defaultFonts = {
      serif = ["Noto Serif Regular"];
      sansSerif = ["Liberation Sans Regular"];
      monospace = ["Hack"];
    };
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

  # To enable Sway in Home Manger
  security.polkit.enable = true;

  networking.firewall = {
    enable = true;
    allowPing = true;
    # Open ports in the firewall.
    allowedTCPPorts = [
      22    # SSH
      80    # HTTP
      443   # HTTPS
    ];

    # allowedUDPPorts = [ ... ];
  };

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
