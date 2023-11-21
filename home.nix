{ config, pkgs, lib, ... }: {

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
        ".config/zathura/zathurarc".text = ''
          # zathura config gile
          set selection-clipboard clipboard
        '';
      };
    # Packages that should be installed to the user profile.
    packages = with pkgs; [
      networkmanagerapplet
      gparted
      #audacity
      #gimp
      zellij
      vivaldi
      wezterm
      signal-desktop
      whatsapp-for-linux
      threema-desktop
      discord
      slack
      openvpn
      #libreoffice-qt
      pinta
      hunspell
      hunspellDicts.de_DE
      hunspellDicts.en_US-large
      hunspellDicts.es_MX
      firefox
      gnome.pomodoro
      picocom
      spotify
      zathura
      qalculate-qt
      nxpmicro-mfgtools
      jdiskreport
      xfce.thunar-archive-plugin
      xfce.thunar-volman
      xfce.tumbler # thunar thumbnails
      #xfce.xfce4-volumed-pulse
      xfce.xfconf # thunar save settings
      (xfce.thunar.override {
        thunarPlugins = with pkgs; [
          xfce.thunar-volman
          xfce.thunar-archive-plugin
          xfce.thunar-media-tags-plugin
        ];
      })
      # to work with thunar-archive-plugin
      gnome.file-roller
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

      zellij_settings = {
        target = "zellij/config.kdl";
        source = ./zellij/config.kdl;
      };

    };
    mimeApps = {
      enable = true;
      defaultApplications = {
        "application/pdf" = "zathura.desktop";
        "text/html" = "vivaldi-stable.desktop";
        "x-scheme-handler/http" = "vivaldi-stable.desktop";
        "x-scheme-handler/https" = "vivaldi-stable.desktop";
        "x-scheme-handler/about" = "vivaldi-stable.desktop";
        "x-scheme-handler/unknown"= "vivaldi-stable.desktop";
      };
      associations.added = {
        "x-scheme-handler/http" = "vivaldi-stable.desktop";
        "x-scheme-handler/https" = "vivaldi-stable.desktop";
      };
    };
  };

  # Enable Sway
  wayland.windowManager.sway = {
    enable = true;
    config = rec {
      keybindings = lib.mkOptionDefault
      {
        "${modifier}+x" = "focus child";
        #"${modifier}+minus" = "scratchpad show, resize 1000x600";
        "${modifier}+Shift+minus" = "floating enable, resize set width 1920 height 1056, move scratchpad";
        # Function keys for brightness and media
        "XF86MonBrightnessDown" = "exec light -U 5";
        "XF86MonBrightnessUp" = "exec light -A 5";
        "XF86AudioRaiseVolume" = "exec 'wpctl set-volume @DEFAULT_AUDIO_SINK@ 3%+'";
        "XF86AudioLowerVolume" = "exec 'wpctl set-volume @DEFAULT_AUDIO_SINK@ 3%-'";
        "XF86AudioMute" = "exec 'wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle'";
        "XF86AudioPlay" = "exec playerctl play-pause";
        "XF86AudioStop" = "exec playerctl stop";
        "XF86AudioNext" = "exec playerctl next";
        "XF86AudioPrev" = "exec playerctl previous";
      };
      # Win key as Modifier
      modifier = "Mod4";
      defaultWorkspace = "workspace number 2";
      colors.focused = {
        background = "#191919";
        border = "#6B3E73";
        childBorder = "#523059";
        indicator = "#000000";
        text = "#FFFFFF";
      };
      menu = "exec ${pkgs.wofi}/bin/wofi -i --show run";
      # Use wezterm as default terminal
      terminal = "wezterm -e zellij"; 
      bars = [
        {
          command = "waybar";
        }
      ];
      input = {
        "*" = {
          xkb_layout = "us,es,de";
        };
      };
      fonts = {
        names = [ "Liberation Sans Regular" "FontAwesome" ];
        style = "Regular";
        size = 8.0;
      };
    };
    extraConfig = ''
      input 1267:12375:ELAN1300:00_04F3:3057_Touchpad {
        tap enabled
        natural_scroll enabled
      }
      input 1:1:AT_Translated_Set_2_keyboard {
        xkb_layout us,es,de
        xkb_options grp:win_space_toggle
      }
    '';
  }; 

  services.mako = {
    enable = true;
    maxVisible = -1;
    defaultTimeout = 5500;
    backgroundColor = "#9959A5EF";
    #borderColor = "#46294CFF";
    borderSize = 0;
    font = "Liberation Sans Regular 9.0";
  };

  # GPG agent for future use with Yubikey
  services.gpg-agent = {
    enable = true;
    enableSshSupport = true;
    enableZshIntegration = true;
  };

  services.swayidle = {
    enable = false;
    events = [
      { event = "before-sleep"; command = "${pkgs.swaylock}/bin/swaylock"; }
      { event = "lock"; command = "lock"; }
    ];
    timeouts = [
      { timeout = 60; command = "${pkgs.swaylock}/bin/swaylock -fF"; }
    ];
  };

  programs = {

    # Let Home Manager install and manage itself.
    home-manager.enable = true;

    # menu bar for sway
    waybar = {
      enable = true;
      settings = {
          mainBar = {
            layer = "bottom";
            position = "top";
            height = 10;
            spacing = 4;
            modules-left = ["sway/workspaces" "sway/mode" "sway/scratchpad" "custom/media"];
            modules-center = ["clock"];
            modules-right = ["pulseaudio" "network" "cpu" "memory" "keyboard-state" "sway/language" "battery" "tray"];

            "sway/workspaces" = {
              disable-scroll = true;
              all-outputs = true;
            };
          };
        };
      style = ''
        * {
          border: none;
          border-radius: 0;
          font-family: "FontAwesome", "Noto";
          font-size: 10px;
        }
        window#waybar {
          background: #201921;
          color: #FFFFFF;
        }
        #workspaces button {
          padding: 0px;
          color: #FFFFFF;
        }
        button {
            /* Use box-shadow instead of border so the text isn't offset */
            box-shadow: inset 0 -3px transparent;
            /* Avoid rounded borders under each button name */
            border: none;
            border-radius: 0;
        }
        button:hover {
            background: inherit;
            box-shadow: inset 0 -3px #ffffff;
        }
        #workspaces button {
            padding: 0 5px;
            background-color: transparent;
            color: #ffffff;
        }
        #workspaces button:hover {
            background: rgba(0, 0, 0, 0.2);
        }
        #workspaces button.focused {
            background-color: #64727D;
            box-shadow: inset 0 -3px #ffffff;
        }
        #workspaces button.urgent {
            background-color: #eb4d4b;
        }
      '';
    };

    # Screen locker for Wayland
    swaylock = {
      enable = false;
      settings = {
        color = "808080";
        font-size = 24;
        indicator-idle-visible = false;
        indicator-radius = 100;
        line-color = "ffffff";
        show-failed-attempts = true;
      };
    };

    wofi = {
      enable = true;
      settings = {
        width = 500;
        height = 240;
      };
      style = ''
        * {
          font-family: "Liberation", "Sans";
          font-size: 12px;
        }
        window {
          margin: 0px;
          border: none;
          /* background-color: #857688; */
          background-color: #201921;
        }
        #input {
          margin: 5px;
          border: none;
          border-radius: 0px;
          background-color: #9D91A0;
        }
        #input:focus:active {
          border: none;
        }
        #inner-box {
          margin: 5px;
          border: none;
          background-color: #9D91A0;
        }
        #outer-box {
          margin: 5px;
          border: none;
          /* background-color: #857688; */
          background-color: #201921;
        }
        #scroll {
          margin: 0px;
          border: none;
        }
        #text {
          margin:5px;
          border: none;
        }
        #entry:selected {
          background-color: #8B6D91;
        }
        #entry:selected #text {
          font-weight: bold;
        }
      '';
    };

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
        onedark-nvim
        #onehalf
        #solarized-nvim
        #nightfox-nvim
        #catppuccin-nvim
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

    # Git config
    git = {
      enable = true;
      userName = "SoRoot";
      userEmail = "lukas.ungerland@gmail.com";
      diff-so-fancy = {
        enable = true;
        rulerWidth = 60;
      };
      aliases = {
        co = "checkout";
        s = "status";
      };
      extraConfig = {
        pull.rebase = false;
        safe.directory = "*";
        diff.tool = "meld";
        difftool.prompt = false;
        difftool."meld".cmd = "meld \"$LOCAL\" \"$REMOTE\"";
        merge.tool = "meld";
        mergetool."meld".cmd = "meld \"$LOCAL\" \"$MERGED\" \"$REMOTE\" --output \"MERGED\"";
        #mergetool."meld".cmd = "meld \"$LOCAL\" \"$BASE\" \"$REMOTE\" --output \"MERGED\"";
        # - $LOCAL is the file in the current branch (e.g. master).
        # - $REMOTE is the file in the branch being merged (e.g. branch_name).
        # - $MERGED is the partially merged file with the merge conflict information in it.
        # - $BASE is the shared commit ancestor of $LOCAL and $REMOTE, this is to say the file as it was
        #   when the branch containing $REMOTE was originally created.
      };
    };

    # Shell (ZSH)
    zsh = {
      enable = true;
      historySubstringSearch.enable = true;
      enableAutosuggestions = true;
      syntaxHighlighting.enable = true;
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

        # Terminal format config. Not using these configs as I use the tmux set-title option
        #terminal.autoTitle = true;
        #terminal.multiplexerTitleFormat = "%s";
        #terminal.tabTitleFormat = "%m: %s";
        #terminal.windowTitleFormat = "%n@%m: %s";
      };
      # Additions for .zshrc
      #initExtra =  ''
        ## Autostart of tmux on terminal launch
        #if [ "$TMUX" = "" ]; then tmux; fi
      #'';
    };

    #FZF
    fzf = {
      enable = true;
      enableZshIntegration = true;
    };

    # Other
    zellij = {
      enable = true;
    };


    #tldr
    tealdeer.enable = true;

    #TUX
    tmux = {
      enable = true;
      aggressiveResize = true;
      escapeTime = 20;
      mouse = true;
      keyMode = "vi";
      historyLimit = 50000;
      baseIndex = 1;
      terminal = "xterm-256color";
      extraConfig = ''
        # Colors for nested tmux
        color_status_text="colour245"
        color_window_off_status_bg="colour238"
        color_light="white" #colour015
        color_dark="colour232" # black= colour232
        color_window_off_status_current_bg="colour254"
        color_window_on_status_bg="colour90"
        color_border_fg="colour18"
        color_border_active_fg="colour163"

        # Use system clipboard
        #set -s set-clipboard on
        set -s copy-command 'wl-clipboard'
        # External clipboard tools
        #set -s copy-command 'xsel -i'

        # Set the window title of wezterm
        set-option -g set-titles on
        set-option -g set-titles-string '#W'

        set -g status-interval 1
        set -g automatic-rename on
        set -g automatic-rename-format '#{b:pane_current_path}'
        set -g renumber-windows on

        # Suggested by prezto tmux module
        #set-option -g destroy-unattached off

        # Wezterm User Vars
        set -g allow-passthrough on

        # Set colors
        set -g status-style "bg=$color_window_on_status_bg"
        set -g pane-border-style "fg=$color_border_fg"
        set -g pane-active-border-style "fg=$color_border_active_fg"

        # Change pane with hjkl
        bind h select-pane -L
        bind j select-pane -D
        bind k select-pane -U
        bind l select-pane -R

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
