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
      whatsapp-for-linux
      threema-desktop
      discord
      slack
      libreoffice-qt
      hunspell
      hunspellDicts.de_DE
      hunspellDicts.en_US-large
      hunspellDicts.es_MX
      firefox
      gnome.pomodoro
      picocom
      spotify
      zathura
      microsoft-edge
      qalculate-qt
      nxpmicro-mfgtools
      # file manager
      nnn
      # LSPconfig
      ctags
      llvmPackages_15.clang-unwrapped
      nodePackages_latest.vscode-langservers-extracted
      nodePackages_latest.bash-language-server
      nil
    ];
    shellAliases = {
      v = "nvim";
      z = "zathura";
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

      nvim_lua_themes = {
        target = "nvim/lua/themes.lua";
        source = ./nvim/themes.lua;
      };

      nvim_lua_lspconfig = {
        target = "nvim/lua/lsp-config.lua";
        source = ./nvim/lsp-config.lua;
      };

      wezterm_settings = {
        target = "wezterm/wezterm.lua";
        source = ./wezterm/wezterm.lua;
      };

      onedrive_work_settings = {
        target = "onedrive-work/config";
        source = ./onedrive-work/config;
      };

      onedrive_personal_settings = {
        target = "onedrive-personal/config";
        source = ./onedrive-personal/config;
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
        #onehalf
        #solarized-nvim
        #nightfox-nvim
        catppuccin-nvim
        #sonokai
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
        require('themes')
        require('lsp-config')
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
      mouse = true;
      keyMode = "vi";
      historyLimit = 50000;
      baseIndex = 1;
      terminal = "tmux-256color";
      extraConfig = ''
        set -s set-clipboard on
        set -g status-interval 1
        set -g automatic-rename on
        set -g automatic-rename-format '#{b:pane_current_path}'
        set -g renumber-windows on

        bind '"' split-window -c "#{pane_current_path}"
        bind % split-window -h -c "#{pane_current_path}"
        bind c new-window -c "#{pane_current_path}"
      '';
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

  # Onedrive systemd service launcher for work/personal.
  home.file.".config/onedrive-launcher".text = ''
    onedrive-personal
    onedrive-work
    '';
}
