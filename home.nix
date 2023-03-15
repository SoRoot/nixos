{ config, pkgs, ... }: {

  # Lookup all home-manager options here:
  # https://rycee.gitlab.io/home-manager/options.html

  # Allow "unfree" licenced packages in home-manager
  nixpkgs.config.allowUnfree = true;

  # Packages that should be installed to the user profile.
  home = {
    packages = with pkgs; [
      zellij
      vivaldi
      wezterm
      zettlr
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
      qpdfview
    ];
    shellAliases = {
      v = "nvim";
    };
  };

  xdg = {
    enable = true;
    configFile = {

      nvim_lua_settings = {
        target = "nvim/lua/settings.lua";
        source = ./nvim/settings.lua;
      };

      nvim_lua_mappings = {
        target = "nvim/lua/mappings.lua";
        source = ./nvim/mappings.lua;
      };

      wezterm_settings = {
        target = "wezterm/wezterm.lua";
        source = ./wezterm/wezterm.lua;
      };
    };
  };


  programs = {

    # Let Home Manager install and manage itself.
    home-manager.enable = true;

    # Neovim
    neovim = {
      enable = true;
      defaultEditor = true;

      plugins = with pkgs.vimPlugins; [
        #tokyonight-nvim
        #onedark-nvim
        #solarized-nvim
        nightfox-nvim
        #catppuccin-nvim
        vim-nix
        tagbar
        nerdcommenter
        fzf-vim
        nvim-lspconfig
        nvim-cmp
        cmp-nvim-lsp
        cmp_luasnip
        luasnip
        gitsigns-nvim
        vim-fugitive
        vim-autoformat
      ];

      vimAlias = true;
      viAlias = true;
      vimdiffAlias = true;
      extraLuaConfig = ''
        require('settings')
        require('mappings')
      '';
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
      terminal = "xterm-256color";
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
