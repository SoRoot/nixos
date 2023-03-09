{ config, pkgs, ... }: {

  # Lookup all home-manager options here:
  # https://rycee.gitlab.io/home-manager/options.html

  # Allow "unfree" licenced packages in home-manager
  nixpkgs.config.allowUnfree = true;

  # Packages that should be installed to the user profile.
  home.packages = with pkgs; [
    htop
    zellij
    vivaldi
    wezterm
    zettlr
    tmux
    signal-desktop
    slack
    libreoffice-qt
    hunspell
    hunspellDicts.de_DE
    hunspellDicts.en_US-large
    hunspellDicts.es_MX
    firefox
    gnome.pomodoro
    onedrive
    picocom
    spotify
    wl-clipboard
  ];

  home.shellAliases = {
    v = "nvim";
  };


  programs = {

    # Let Home Manager install and manage itself.
    home-manager.enable = true;

    # Neovim
    neovim = {
      enable = true;
      defaultEditor = true;

      plugins = with pkgs.vimPlugins; [
        vim-nix
      ];

      vimAlias = true;
      viAlias = true;
      vimdiffAlias = true;
    };

    # Shell (ZSH)
    zsh = {
      enable = true;
      historySubstringSearch.enable = true;
      enableAutosuggestions = true;
      enableSyntaxHighlighting = true;
      autocd = true;

      prezto = {
        enable = true;
        prompt.theme = "pure";

        # Case insensitive completion
        caseSensitive = false;

        # Autoconvert .... to ../..
        editor.dotExpansion = true;

        # Prezto modules to load
        pmodules = [ "utility" "editor" "directory" "prompt" ];

        terminal.autoTitle = true;
      };
    };

    #TMUX
    tmux = {
      enable = true;
      aggressiveResize = true;
      escapeTime = 20;
      keyMode = "vi";
      historyLimit = 50000;
      baseIndex = 1;
      mouse = true;
      plugins = with pkgs; [
        tmuxPlugins.cpu
        {
          plugin = tmuxPlugins.resurrect;
          extraConfig = "set -g @resurrect-strategy-nvim 'session'";
        }
        {
          plugin = tmuxPlugins.continuum;
          extraConfig = "set -g @continuum-restore 'on'";
        }
        {
          plugin = tmuxPlugins.yank;
        }
      ];
    };

    #FZF
    fzf = {
      enable = true;
      enableZshIntegration = true;
    };

    # Other
    zellij.enable = true;
    tealdeer.enable = true;
  };


  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "22.11";



}
