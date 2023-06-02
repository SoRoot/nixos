{ config, pkgs, ... }: {

  # Lookup all home-manager options here:
  # https://rycee.gitlab.io/home-manager/options.html

  # Allow "unfree" licenced packages in home-manager
  nixpkgs.config.allowUnfree = true;

  home = {
    # This value determines the Home Manager release that your
    # configuration is compatible with. This helps avoid breakage
    # when a new Home Manager release introduces backwards
    # incompatible changes.
    #
    # You can update Home Manager without changing this value. See
    # the Home Manager release notes for a list of state version
    # changes in each release.
    stateVersion = "22.11";

    # Set configuration dotfiles
    file = {
        ".config/onedrive-launcher".text = ''
          # Onedrive systemd service launcher for work/personal.
          onedrive-personal
          onedrive-work
        '';
        ".Xresources".text = ''
          # Xresources set to work with tmux clipboard
          XTerm*disallowedWindowOps: 20,21,SetXprop
        '';
        ".config/zathura/zathurarc".text = ''
          # zathura config gile
          set selection-clipboard clipboard
        '';
      };
    # Packages that should be installed to the user profile.
    packages = with pkgs; [
      razergenie
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
      mupdf
      microsoft-edge
      qalculate-qt
      nxpmicro-mfgtools
      jdiskreport
      xfce.thunar-archive-plugin
      xfce.thunar-volman
      xfce.tumbler # thunar thumbnails
      xfce.xfce4-volumed-pulse
      xfce.xfconf # thunar save settings
      (xfce.thunar.override {
        thunarPlugins = with pkgs; [
          xfce.thunar-volman
          xfce.thunar-archive-plugin
          xfce.thunar-media-tags-plugin
        ];
      })
      # device tree compiler
      dtc
      # LSPconfig
      ctags
      llvmPackages_15.clang-unwrapped
      nodePackages_latest.vscode-langservers-extracted
      nodePackages_latest.bash-language-server
      nil
    ];
    shellAliases = {
      v = "nvim";
      za = "zathura";
      gs = "git status";
    };
  };

  # Set configuration dotfiles for vim, wezterm and onedrive
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

  # GPG agent for future use with Yubikey
  services.gpg-agent = {
    enable = true;
    enableSshSupport = true;
    enableZshIntegration = true;
  };

  programs = {

    # Let Home Manager install and manage itself.
    home-manager.enable = true;

    # GPG
    gpg.enable = true;

    # Pazi - directory autojump tool
    pazi.enable = true;

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
        cmp-spell
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

    # SSH config file for Regor Server Wdno
    ssh = {
      enable = true;
      matchBlocks = {
        "regor" = {
          hostname = "antares.code-ing.com";
          user = "lungerland";
          port = 40;
          identityFile = "~/.ssh/regor.ed25519";
        };
      };
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
        pmodules = [ "utility" "editor" "directory" "prompt" "terminal" "tmux" ];

        # Terminal format config
        terminal.autoTitle = true;
        terminal.tabTitleFormat = "%m: %s";
        terminal.windowTitleFormat = "%n@%m: %s";
      };
      # Additions for .zshrc
      initExtra =  ''
        # Autostart of tmux on terminal launch
        if [ "$TMUX" = "" ]; then tmux; fi
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

    #TMUX
    tmux = {
      enable = true;
      aggressiveResize = true;
      escapeTime = 20;
      #mouse = true;
      keyMode = "vi";
      historyLimit = 50000;
      baseIndex = 1;
      terminal = "tmux-256color";
      extraConfig = ''
        # Colors for nested tmux
        color_status_text="colour245"
        color_window_off_status_bg="colour238"
        color_light="white" #colour015
        color_dark="colour232" # black= colour232
        color_window_off_status_current_bg="colour254"

        # Use system clipboard
        set -s set-clipboard on
        # External clipboard tools
        #set -s copy-command 'xsel -i'

        set -g status-interval 1
        set -g automatic-rename on
        set -g automatic-rename-format '#{b:pane_current_path}'
        set -g renumber-windows on

        # Suggested by prezto tmux module
        #set-option -g destroy-unattached off

        # Wezterm User Vars
        set -g allow-passthrough on

        # Config for neseted tmux
        bind '"' split-window -c "#{pane_current_path}"
        bind % split-window -h -c "#{pane_current_path}"
        bind c new-window -c "#{pane_current_path}"

        bind -T root F12  \
          set prefix None \;\
          set key-table off \;\
          set status-style "fg=$color_status_text,bg=$color_window_off_status_bg" \;\
          set window-status-current-style "fg=$color_dark,bold,bg=$color_window_off_status_current_bg" \;\
          set window-status-current-format "#[fg=$color_window_off_status_bg,bg=$color_window_off_status_current_bg]$separator_powerline_right#[default] #I:#W# #[fg=$color_window_off_status_current_bg,bg=$color_window_off_status_bg]$separator_powerline_right#[default]" \;\
          if -F '#{pane_in_mode}' 'send-keys -X cancel' \;\
          refresh-client -S \;\

        bind -T off F12 \
          set -u prefix \;\
          set -u key-table \;\
          set -u status-style \;\
          set -u window-status-current-style \;\
          set -u window-status-current-format \;\
          refresh-client -S
          
        wg_is_keys_off="#[fg=$color_light,bg=$color_window_off_indicator]#([ $(tmux show-option -qv key-table) = 'off' ] && echo 'OFF')#[default]"

        set -g status-right "$wg_is_keys_off"
      '';
    };
  };
}
