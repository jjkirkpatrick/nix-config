{ pkgs, ... }:
{
  programs.waybar = {
    enable = true;
    package = pkgs.waybar;

    settings = [
      # Top Bar Configuration
      {
        name = "top_bar";
        layer = "top";
        position = "top";
        height = 40;
        spacing = 8;
        margin-top = 8;
        margin-left = 12;
        margin-right = 12;
        margin-bottom = 0;
        output = "DP-3";

        modules-left = [ "hyprland/workspaces" "hyprland/submap" ];
        modules-center = [ "clock#time" "custom/separator" "clock#week" "custom/separator_dot" "clock#month" "custom/separator" "clock#calendar" ];
        modules-right = [ "bluetooth" "network" "group/misc" "custom/logout_menu" ];

        # Module configurations
        "hyprland/workspaces" = {
          format = "{icon}";
          format-icons = {
            "1" = "";
            "2" = "";
            "3" = "";
            "4" = "";
            "5" = "";
            "6" = "";
            "7" = "";
            "8" = "";
            "9" = "";
            "10" = "";
            default = "";
            special = "";
          };
          persistent-workspaces = {
            "1" = [];
            "2" = [];
            "3" = [];
            "4" = [];
            "5" = [];
          };
          on-click = "activate";
          sort-by-number = true;
          show-special = true;
        };

        "hyprland/submap" = {
          format = "<span color='#10B981'>Mode:</span> {}";
          tooltip = false;
        };

        "clock#time" = {
          format = "{:%I:%M %p}";
        };

        "custom/separator" = {
          format = "|";
          tooltip = false;
        };

        "custom/separator_dot" = {
          format = "•";
          tooltip = false;
        };

        "clock#week" = {
          format = "{:%a}";
        };

        "clock#month" = {
          format = "{:%h}";
        };

        "clock#calendar" = {
          format = "{:%F}";
          tooltip-format = "<tt><small>{calendar}</small></tt>";
          actions = {
            on-click-right = "mode";
          };
          calendar = {
            mode = "month";
            mode-mon-col = 3;
            weeks-pos = "right";
            on-scroll = 1;
            on-click-right = "mode";
            format = {
              months = "<span color='#8B5CF6'><b>{}</b></span>";
              days = "<span color='#F8FAFC'><b>{}</b></span>";
              weeks = "<span color='#06B6D4'><b>W{}</b></span>";
              weekdays = "<span color='#10B981'><b>{}</b></span>";
              today = "<span color='#F97316'><b><u>{}</u></b></span>";
            };
          };
        };

        bluetooth = {
          format = "󰂯";
          format-disabled = "󰂲";
          format-connected = "󰂱 {device_alias}";
          format-connected-battery = "󰂱 {device_alias} (󰥉 {device_battery_percentage}%)";
          tooltip-format = "{controller_alias}	{controller_address} ({status})

{num_connections} connected";
          tooltip-format-disabled = "bluetooth off";
          tooltip-format-connected = "{controller_alias}	{controller_address} ({status})

{num_connections} connected

{device_enumerate}";
          tooltip-format-enumerate-connected = "{device_alias}	{device_address}";
          tooltip-format-enumerate-connected-battery = "{device_alias}	{device_address}	({device_battery_percentage}%)";
          max-length = 35;
          on-click = "blueman-manager";
        };

        network = {
          format-wifi = "{icon}({signalStrength}%) {essid}";
          format-icons = [ "󰤯" "󰤟" "󰤢" "󰤥" "󰤨" ];
          format-ethernet = "󰈀 Connected";
          format-linked = "󰈀 {ifname} (No IP)";
          format-disconnected = "󰤫 Disconnected";
          tooltip-format-wifi = "SSID: {essid}({signalStrength}%), {frequency} MHz
Interface: {ifname}
IP: {ipaddr}
GW: {gwaddr}

<span color='#10B981'>{bandwidthUpBits}</span>	<span color='#F97316'>{bandwidthDownBits}</span>	<span color='#8B5CF6'>󰹹{bandwidthTotalBits}</span>";
          tooltip-format-disconnected = "<span color='#F97316'>disconnected</span>";
          max-length = 35;
          on-click = "nm-connection-editor";
        };

        "group/misc" = {
          orientation = "horizontal";
          modules = [
            "privacy"
            "custom/media"
            "custom/night_mode"
            "idle_inhibitor"
          ];
        };

        privacy = {
          icon-spacing = 1;
          icon-size = 12;
          transition-duration = 250;
          modules = [
            {
              type = "audio-in";
            }
            {
              type = "screenshare";
            }
          ];
        };

        "custom/media" = {
          format = "{icon}󰎈";
          restart-interval = 2;
          return-type = "json";
          format-icons = {
            Playing = "";
            Paused = "";
          };
          max-length = 35;
          exec = "playerctl -a metadata --format '{\"text\": \"{{artist}} - {{markup_escape(title)}}\", \"tooltip\": \"{{playerName}} : {{markup_escape(title)}}\", \"alt\": \"{{status}}\", \"class\": \"{{status}}\"}' -F";
          on-click = "playerctl play-pause";
          on-click-right = "playerctl next";
          on-click-middle = "playerctl prev";
          on-scroll-up = "playerctl volume 0.05+";
          on-scroll-down = "playerctl volume 0.05-";
          smooth-scrolling-threshold = "0.1";
        };

        "custom/night_mode" = {
          return-type = "json";
          interval = 1;
          exec = "if pgrep -x gammastep > /dev/null; then echo '{\"text\": \"󰌶\", \"class\": \"active\", \"tooltip\": \"Night mode: ON\"}'; else echo '{\"text\": \"󰌵\", \"class\": \"inactive\", \"tooltip\": \"Night mode: OFF\"}'; fi";
          on-click = "pkill gammastep || gammastep &";
        };

        idle_inhibitor = {
          format = "{icon}";
          format-icons = {
            activated = "󰛐";
            deactivated = "󰛑";
          };
          tooltip-format-activated = "idle-inhibitor <span color='#10B981'>on</span>";
          tooltip-format-deactivated = "idle-inhibitor <span color='#F97316'>off</span>";
          start-activated = false;
        };

        "custom/logout_menu" = {
          return-type = "json";
          exec = "echo '{\"text\":\"󰐥\", \"tooltip\": \"logout menu\"}'";
          interval = "once";
          on-click = "wlogout";
        };
      }

      # Bottom Bar Configuration
      {
        name = "bottom_bar";
        layer = "top";
        position = "bottom";
        height = 40;
        spacing = 8;
        margin-top = 0;
        margin-left = 12;
        margin-right = 12;
        margin-bottom = 8;
        output = "DP-3";

        modules-left = [ "user" ];
        modules-center = [ "hyprland/window" ];
        modules-right = [ "hyprland/language" ];

        "hyprland/window" = {
          format = "👼 {title} 😈";
          max-length = 50;
          separate-outputs = true;
        };

        "hyprland/language" = {
          format-en = "🇺🇸 ENG";
          format-uk = "🇺🇦 UKR";
          format-ru = "🇷🇺 RUS";
          keyboard-name = "at-translated-set-2-keyboard";
          on-click = "hyprctl switchxkblayout at-translated-set-2-keyboard next";
        };

        "keyboard-state" = {
          capslock = true;
          format = "{name} {icon}";
          format-icons = {
            locked = "󰌾";
            unlocked = "󰍀";
          };
        };

        user = {
          format = " <span color='#06B6D4'>{user}</span> (up <span color='#8B5CF6'>{work_d} d</span> <span color='#06B6D4'>{work_H} h</span> <span color='#F97316'>{work_M} min</span> <span color='#10B981'>↑</span>)";
          icon = true;
        };
      }

      # Left Bar Configuration
      {
        name = "left_bar";
        layer = "top";
        position = "left";
        spacing = 4;
        width = 80;
        margin-top = 10;
        margin-bottom = 10;
        margin-left = 8;
        margin-right = 0;
        output = "DP-3";

        modules-left = [ "wlr/taskbar" ];
        modules-center = [ "cpu" "memory" "disk" "temperature" "pulseaudio" "systemd-failed-units" ];
        modules-right = [ "tray" ];

        "wlr/taskbar" = {
          format = "{icon}";
          icon-size = 20;
          icon-theme = "Papirus-Dark";
          tooltip-format = "{title}";
          on-click = "activate";
          on-click-right = "close";
          on-click-middle = "fullscreen";
        };

        tray = {
          icon-size = 18;
          spacing = 4;
        };

        cpu = {
          format = "󰻠{usage}%";
          states = {
            high = 90;
            upper-medium = 70;
            medium = 50;
            lower-medium = 30;
            low = 10;
          };
          on-click = "kitty btop";
          tooltip = true;
          interval = 2;
        };

        memory = {
          format = "󰍛{percentage}%";
          tooltip-format = "Main: ({used} GiB/{total} GiB)({percentage}%), available {avail} GiB
Swap: ({swapUsed} GiB/{swapTotal} GiB)({swapPercentage}%), available {swapAvail} GiB";
          states = {
            high = 90;
            upper-medium = 70;
            medium = 50;
            lower-medium = 30;
            low = 10;
          };
          on-click = "kitty btop";
          interval = 2;
        };

        disk = {
          format = "󰋊{percentage_used}%";
          tooltip-format = "({used}/{total})({percentage_used}%) in '{path}', available {free}({percentage_free}%)";
          states = {
            high = 90;
            upper-medium = 70;
            medium = 50;
            lower-medium = 30;
            low = 10;
          };
          on-click = "kitty btop";
        };

        temperature = {
          tooltip = false;
          thermal-zone = 0;
          critical-threshold = 80;
          format = "{icon}{temperatureC}°C";
          format-critical = "🔥{icon}{temperatureC}°C";
          format-icons = [ "" "" "" "" "" ];
        };

        battery = {
          format = "󰂄 No Battery";
          tooltip = "Desktop system - no battery";
        };

        backlight = {
          format = "󰛨 Desktop";
          tooltip = "Desktop system - no backlight control";
        };

        pulseaudio = {
          states = {
            high = 90;
            upper-medium = 70;
            medium = 50;
            lower-medium = 30;
            low = 10;
          };
          tooltip-format = "{desc}";
          format = "{icon}{volume}%
{format_source}";
          format-bluetooth = "󰂱{icon}{volume}%
{format_source}";
          format-bluetooth-muted = "󰂱󰝟{volume}%
{format_source}";
          format-muted = "󰝟{volume}%
{format_source}";
          format-source = "󰍬{volume}%";
          format-source-muted = "󰍭{volume}%";
          format-icons = {
            headphone = "󰋋";
            hands-free = "";
            headset = "󰋎";
            phone = "󰄜";
            portable = "󰦧";
            car = "󰄋";
            speaker = "󰓃";
            hdmi = "󰡁";
            hifi = "󰋌";
            default = [ "󰕿" "󰖀" "󰕾" ];
          };
          reverse-scrolling = true;
          reverse-mouse-scrolling = true;
          on-click = "pavucontrol";
          on-click-right = "pactl set-sink-mute @DEFAULT_SINK@ toggle";
          on-scroll-up = "pactl set-sink-volume @DEFAULT_SINK@ +2%";
          on-scroll-down = "pactl set-sink-volume @DEFAULT_SINK@ -2%";
        };

        "systemd-failed-units" = {
          format = "✗ {nr_failed}";
        };
      }
    ];

    style = ''
      /* Dark Space Theme Color Palette:
       * Deep Space: #0B0D17 (primary background)
       * Void Black: #0F141E (secondary background)
       * Shadow Gray: #131820 (tertiary background)
       * Dark Slate: #1A1F2E (elements background)
       * Cosmic Gray: #252A38 (hover states)
       * Star White: #F8FAFC (primary text)
       * Slate Blue: #E2E8F0 (secondary text)
       * Accent colors: #10B981 (green), #F97316 (orange), #06B6D4 (cyan), #8B5CF6 (purple)
       */

      * {
        font-family: "JetBrains Mono Nerd Font", "Font Awesome 6 Free", "Font Awesome 6 Brands";
        font-size: 13px;
        font-weight: 600;
        border: none;
        border-radius: 0;
        min-height: 0;
      }

      /* Common bar styling */
      window#waybar {
        background: linear-gradient(135deg, 
          rgba(11, 13, 23, 0.98) 0%,
          rgba(15, 20, 30, 0.95) 50%,
          rgba(20, 25, 35, 0.96) 100%);
        border: 1px solid rgba(30, 35, 45, 0.4);
        color: #F8FAFC;
        box-shadow: 
          0 0 15px rgba(11, 13, 23, 0.3),
          inset 0 1px 0 rgba(248, 250, 252, 0.05);
        transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
      }

      /* Top bar specific styling */
      window#waybar.top_bar {
        border-radius: 16px;
      }

      /* Bottom bar specific styling */
      window#waybar.bottom_bar {
        border-radius: 16px;
      }

      /* Left bar specific styling */
      window#waybar.left_bar {
        border-radius: 12px;
      }

      window#waybar.hidden {
        opacity: 0.1;
      }

      #workspaces {
        background: linear-gradient(135deg, 
          rgba(11, 13, 23, 0.9) 0%,
          rgba(15, 18, 25, 0.8) 100%);
        border: 1px solid rgba(25, 30, 40, 0.4);
        border-radius: 12px;
        margin: 6px 10px;
        padding: 2px 6px;
        box-shadow: 
          0 4px 15px rgba(11, 13, 23, 0.4),
          inset 0 1px 0 rgba(248, 250, 252, 0.03);
      }

      #workspaces button {
        padding: 6px 10px;
        margin: 2px;
        border-radius: 8px;
        color: #F8FAFC;
        background: transparent;
        transition: all 0.4s cubic-bezier(0.4, 0, 0.2, 1);
        font-size: 16px;
        text-shadow: 0 0 5px rgba(25, 30, 40, 0.3);
      }

      #workspaces button:hover {
        background: linear-gradient(135deg, 
          rgba(25, 30, 40, 0.4) 0%,
          rgba(30, 35, 45, 0.3) 100%);
        color: #A0A8B8;
        box-shadow: 
          0 0 10px rgba(25, 30, 40, 0.3),
          inset 0 1px 0 rgba(248, 250, 252, 0.05);
      }

      #workspaces button.active {
        background: linear-gradient(135deg, 
          rgba(35, 40, 55, 0.8) 0%,
          rgba(40, 45, 60, 0.7) 100%);
        color: #E2E8F0;
        font-weight: 800;
        box-shadow: 
          0 0 15px rgba(35, 40, 55, 0.4),
          0 2px 8px rgba(25, 30, 40, 0.3),
          inset 0 1px 0 rgba(248, 250, 252, 0.08);
      }

      #workspaces button.urgent {
        background: linear-gradient(135deg, 
          rgba(249, 115, 22, 0.8) 0%,
          rgba(239, 68, 68, 0.6) 100%);
        color: #0B0D17;
      }

      /* Group styling for pill-like containers */
      #group-misc {
        background: linear-gradient(135deg, 
          rgba(11, 13, 23, 0.9) 0%,
          rgba(15, 18, 25, 0.8) 100%);
        border: 1px solid rgba(25, 30, 40, 0.4);
        border-radius: 12px;
        margin: 6px 10px;
        padding: 2px 6px;
        box-shadow: 
          0 4px 15px rgba(11, 13, 23, 0.4),
          inset 0 1px 0 rgba(248, 250, 252, 0.03);
      }

      /* Individual module styling */
      #submap,
      #window,
      #user,
      #language,
      #keyboard-state {
        background: linear-gradient(135deg, 
          rgba(11, 13, 23, 0.8) 0%,
          rgba(18, 22, 30, 0.7) 100%);
        border: 1px solid rgba(25, 30, 40, 0.3);
        border-radius: 10px;
        margin: 6px 8px;
        padding: 6px 14px;
        color: #F8FAFC;
        font-weight: 500;
      }

      /* Clock modules - center group */
      #clock {
        background: linear-gradient(135deg, 
          rgba(35, 40, 55, 0.9) 0%,
          rgba(30, 35, 50, 0.8) 50%,
          rgba(25, 30, 45, 0.85) 100%);
        border: 1px solid rgba(45, 50, 65, 0.4);
        border-radius: 12px;
        margin: 6px 4px;
        padding: 6px 12px;
        color: #E2E8F0;
        font-weight: 800;
        font-size: 13px;
        box-shadow: 
          0 0 12px rgba(25, 30, 40, 0.3),
          inset 0 1px 0 rgba(248, 250, 252, 0.08);
      }

      /* Separator styling */
      #custom-separator,
      #custom-separator_dot {
        background: transparent;
        border: none;
        color: #64748B;
        margin: 6px 2px;
        padding: 6px 4px;
        font-weight: 400;
      }

      /* Network and Bluetooth */
      #network,
      #bluetooth {
        background: transparent;
        border: none;
        border-radius: 8px;
        margin: 2px;
        padding: 6px 12px;
        color: #06B6D4;
        font-weight: 600;
        transition: all 0.3s ease;
        min-width: 60px;
      }

      #network:hover,
      #bluetooth:hover {
        background: linear-gradient(135deg, 
          rgba(6, 182, 212, 0.15) 0%,
          rgba(25, 30, 40, 0.4) 100%);
        box-shadow: 
          0 0 10px rgba(6, 182, 212, 0.3),
          inset 0 1px 0 rgba(248, 250, 252, 0.05);
      }

      /* Misc group modules */
      #privacy,
      #custom-media,
      #custom-night_mode,
      #idle_inhibitor {
        background: transparent;
        border: none;
        border-radius: 8px;
        margin: 2px;
        padding: 6px 8px;
        color: #F8FAFC;
        font-weight: 600;
        transition: all 0.3s ease;
      }

      #privacy:hover,
      #custom-media:hover,
      #custom-night_mode:hover,
      #idle_inhibitor:hover {
        background: linear-gradient(135deg, 
          rgba(248, 250, 252, 0.08) 0%,
          rgba(25, 30, 40, 0.4) 100%);
        box-shadow: 
          0 0 8px rgba(248, 250, 252, 0.15),
          inset 0 1px 0 rgba(248, 250, 252, 0.05);
      }

      /* Night mode active state */
      #custom-night_mode.active {
        color: #F97316;
      }

      /* Logout menu */
      #custom-logout_menu {
        background: linear-gradient(135deg, 
          rgba(11, 13, 23, 0.9) 0%,
          rgba(15, 18, 25, 0.8) 100%);
        border: 1px solid rgba(25, 30, 40, 0.4);
        border-radius: 12px;
        margin: 6px 10px;
        padding: 6px 12px;
        color: #F97316;
        font-weight: 600;
        transition: all 0.3s ease;
        box-shadow: 
          0 4px 15px rgba(11, 13, 23, 0.4),
          inset 0 1px 0 rgba(248, 250, 252, 0.03);
      }

      #custom-logout_menu:hover {
        background: linear-gradient(135deg, 
          rgba(249, 115, 22, 0.15) 0%,
          rgba(25, 30, 40, 0.4) 100%);
        box-shadow: 
          0 0 12px rgba(249, 115, 22, 0.3),
          inset 0 1px 0 rgba(248, 250, 252, 0.05);
      }

      /* Left bar modules */
      #taskbar,
      #tray {
        background: linear-gradient(135deg, 
          rgba(11, 13, 23, 0.9) 0%,
          rgba(15, 18, 25, 0.8) 100%);
        border: 1px solid rgba(25, 30, 40, 0.4);
        border-radius: 10px;
        margin: 4px 6px;
        padding: 4px 8px;
        color: #F8FAFC;
        font-weight: 600;
        transition: all 0.3s ease;
        box-shadow: 
          0 2px 8px rgba(11, 13, 23, 0.3),
          inset 0 1px 0 rgba(248, 250, 252, 0.03);
      }

      #cpu,
      #memory,
      #disk,
      #temperature,
      #pulseaudio,
      #systemd-failed-units {
        background: linear-gradient(135deg, 
          rgba(11, 13, 23, 0.85) 0%,
          rgba(18, 22, 30, 0.8) 100%);
        border: 1px solid rgba(25, 30, 40, 0.3);
        border-radius: 8px;
        margin: 2px 6px;
        padding: 4px 8px;
        color: #F8FAFC;
        font-weight: 600;
        transition: all 0.3s ease;
        box-shadow: 0 2px 6px rgba(11, 13, 23, 0.25);
        font-size: 11px;
      }

      /* Left bar color coding */
      #cpu {
        color: #10B981;
        border-color: rgba(16, 185, 129, 0.3);
      }

      #memory {
        color: #F97316;
        border-color: rgba(249, 115, 22, 0.2);
      }

      #disk {
        color: #8B5CF6;
        border-color: rgba(139, 92, 246, 0.2);
      }

      #temperature {
        color: #06B6D4;
        border-color: rgba(6, 182, 212, 0.2);
      }


      #pulseaudio {
        color: #8B5CF6;
        border-color: rgba(139, 92, 246, 0.2);
      }

      #systemd-failed-units {
        color: #F97316;
        border-color: rgba(249, 115, 22, 0.3);
      }

      /* Left bar state colors */
      .high { color: #F97316; }
      .upper-medium { color: #F97316; }
      .medium { color: #F8FAFC; }
      .lower-medium { color: #10B981; }
      .low { color: #10B981; }

      /* Tray styling */
      #tray > .passive {
        -gtk-icon-effect: dim;
      }

      #tray > .needs-attention {
        -gtk-icon-effect: highlight;
        background: linear-gradient(135deg, 
          rgba(249, 115, 22, 0.8) 0%,
          rgba(239, 68, 68, 0.6) 100%);
        border-radius: 6px;
      }

      /* Tooltips */
      tooltip {
        background: linear-gradient(135deg, 
          rgba(11, 13, 23, 0.98) 0%,
          rgba(18, 22, 30, 0.95) 100%);
        border: 1px solid rgba(25, 30, 40, 0.4);
        border-radius: 8px;
        color: #F8FAFC;
        box-shadow: 
          0 8px 20px rgba(11, 13, 23, 0.4),
          inset 0 1px 0 rgba(248, 250, 252, 0.05);
      }

      tooltip label {
        color: #F8FAFC;
        text-shadow: 0 0 3px rgba(25, 30, 40, 0.3);
      }
    '';
  };
}