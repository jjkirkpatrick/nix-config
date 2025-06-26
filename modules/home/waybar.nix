{ pkgs, ... }:
{
  programs.waybar = {
    enable = true;
    package = pkgs.waybar;

    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        height = 40;
        spacing = 8;
        margin-top = 8;
        margin-left = 12;
        margin-right = 12;
        margin-bottom = 0;

        # Module layout
        modules-left = [ "hyprland/workspaces" "hyprland/window" ];
        modules-center = [ "clock" ];
        modules-right = [ "pulseaudio" "network" "cpu" "memory" "battery" "tray" ];

        # Module configurations
        "hyprland/workspaces" = {
          format = "{icon}";
          format-icons = {
            "1" = "󰈹";
            "2" = "";
            "3" = "";
            "4" = "󰽰";
            "5" = "󰝚";
            "6" = "";
            "7" = "";
            "8" = "󰊖";
            "9" = "";
            "10" = "󰍹";
            default = "";
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
        };

        "hyprland/window" = {
          format = "{class}";
          max-length = 50;
          separate-outputs = true;
        };

        clock = {
          interval = 1;
          format = "{:%H:%M:%S}";
          format-alt = "{:%A, %B %d, %Y}";
          tooltip-format = "<tt><small>{calendar}</small></tt>";
          calendar = {
            mode = "year";
            mode-mon-col = 3;
            weeks-pos = "right";
            on-scroll = 1;
            on-click-right = "mode";
            format = {
              months = "<span color='#cba6f7'><b>{}</b></span>";
              days = "<span color='#cdd6f4'><b>{}</b></span>";
              weeks = "<span color='#89b4fa'><b>W{}</b></span>";
              weekdays = "<span color='#a6e3a1'><b>{}</b></span>";
              today = "<span color='#f38ba8'><b><u>{}</u></b></span>";
            };
          };
          actions = {
            on-click-right = "mode";
            on-scroll-up = "shift_up";
            on-scroll-down = "shift_down";
          };
        };

        cpu = {
          format = " {usage}%";
          tooltip = true;
          interval = 2;
        };

        memory = {
          format = " {}%";
          tooltip-format = "RAM: {used:0.1f}G/{total:0.1f}G\nSwap: {swapUsed:0.1f}G/{swapTotal:0.1f}G";
          interval = 2;
        };

        network = {
          format-wifi = "󰤨 {signalStrength}%";
          format-ethernet = "󰈀 Connected";
          format-linked = "󰈀 {ifname} (No IP)";
          format-disconnected = "󰤭 Disconnected";
          tooltip-format = "{ifname} via {gwaddr}";
          tooltip-format-wifi = "󰤨 {essid} ({signalStrength}%)\n{ipaddr}/{cidr}";
          tooltip-format-ethernet = "󰈀 {ifname}\n{ipaddr}/{cidr}";
          on-click = "nm-connection-editor";
        };

        pulseaudio = {
          format = "{icon} {volume}%";
          format-muted = "󰖁 Muted";
          format-icons = {
            headphone = "";
            hands-free = "";
            headset = "";
            phone = "";
            portable = "";
            car = "";
            default = ["" "" ""];
          };
          on-click = "pavucontrol";
          on-click-right = "pactl set-sink-mute @DEFAULT_SINK@ toggle";
          on-scroll-up = "pactl set-sink-volume @DEFAULT_SINK@ +2%";
          on-scroll-down = "pactl set-sink-volume @DEFAULT_SINK@ -2%";
        };

        battery = {
          states = {
            warning = 30;
            critical = 15;
          };
          format = "{icon} {capacity}%";
          format-charging = "󰂄 {capacity}%";
          format-plugged = "󰂄 {capacity}%";
          format-alt = "{icon} {time}";
          format-icons = ["󰁺" "󰁻" "󰁼" "󰁽" "󰁾" "󰁿" "󰂀" "󰂁" "󰂂" "󰁹"];
          tooltip-format = "{timeTo}, {capacity}%";
        };

        tray = {
          icon-size = 18;
          spacing = 8;
        };
      };
    };

    style = ''
      * {
        font-family: "JetBrains Mono", "Font Awesome 6 Free";
        font-size: 14px;
        font-weight: 500;
        border: none;
        border-radius: 0;
        min-height: 0;
      }

      window#waybar {
        background: rgba(30, 30, 46, 0.9);
        border: 2px solid rgba(203, 166, 247, 0.4);
        border-radius: 12px;
        color: #cdd6f4;
        transition-property: background-color;
        transition-duration: 0.5s;
      }

      window#waybar.hidden {
        opacity: 0.2;
      }

      #workspaces {
        background: rgba(49, 50, 68, 0.8);
        border-radius: 8px;
        margin: 4px 8px;
        padding: 0 4px;
      }

      #workspaces button {
        padding: 4px 8px;
        margin: 2px;
        border-radius: 6px;
        color: #cdd6f4;
        background: transparent;
        transition: all 0.3s ease;
      }

      #workspaces button:hover {
        background: rgba(203, 166, 247, 0.2);
        color: #cba6f7;
      }

      #workspaces button.active {
        background: rgba(203, 166, 247, 0.8);
        color: #11111b;
        font-weight: bold;
      }

      #workspaces button.urgent {
        background: rgba(243, 139, 168, 0.8);
        color: #11111b;
      }

      #window {
        background: rgba(49, 50, 68, 0.8);
        border-radius: 8px;
        margin: 4px 8px;
        padding: 4px 12px;
        color: #cdd6f4;
        font-weight: 500;
      }

      #clock {
        background: linear-gradient(45deg, rgba(203, 166, 247, 0.8), rgba(137, 180, 250, 0.8));
        border-radius: 8px;
        margin: 4px 8px;
        padding: 4px 16px;
        color: #11111b;
        font-weight: bold;
      }

      #cpu,
      #memory,
      #network,
      #pulseaudio,
      #battery,
      #tray {
        background: rgba(49, 50, 68, 0.8);
        border-radius: 8px;
        margin: 4px 2px;
        padding: 4px 12px;
        color: #cdd6f4;
        font-weight: 500;
      }

      #cpu {
        color: #a6e3a1;
      }

      #memory {
        color: #fab387;
      }

      #network {
        color: #89b4fa;
      }

      #pulseaudio {
        color: #f9e2af;
      }

      #battery {
        color: #a6e3a1;
      }

      #battery.warning {
        color: #fab387;
      }

      #battery.critical {
        color: #f38ba8;
        animation: blink 1s linear infinite;
      }

      @keyframes blink {
        to {
          background-color: rgba(243, 139, 168, 0.8);
          color: #11111b;
        }
      }

      #tray {
        padding: 4px 8px;
      }

      #tray > .passive {
        -gtk-icon-effect: dim;
      }

      #tray > .needs-attention {
        -gtk-icon-effect: highlight;
        background-color: rgba(243, 139, 168, 0.8);
      }

      tooltip {
        background: rgba(30, 30, 46, 0.95);
        border: 2px solid rgba(203, 166, 247, 0.4);
        border-radius: 8px;
        color: #cdd6f4;
      }

      tooltip label {
        color: #cdd6f4;
      }
    '';
  };
}