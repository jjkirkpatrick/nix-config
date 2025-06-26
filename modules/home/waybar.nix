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
        modules-right = [ "pulseaudio" "network" "cpu" "memory" "tray" ];

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
          format-wifi = " {signalStrength}%";
          format-ethernet = " Connected";
          format-linked = " {ifname} (No IP)";
          format-disconnected = " Disconnected";
          tooltip-format = "{ifname} via {gwaddr}";
          tooltip-format-wifi = " {essid} ({signalStrength}%)\n{ipaddr}/{cidr}";
          tooltip-format-ethernet = " {ifname}\n{ipaddr}/{cidr}";
          on-click = "nm-connection-editor";
        };

        pulseaudio = {
          format = "{icon} {volume}%";
          format-muted = " Muted";
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


        tray = {
          icon-size = 18;
          spacing = 8;
        };
      };
    };

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

      window#waybar {
        background: linear-gradient(135deg, 
          rgba(11, 13, 23, 0.98) 0%,
          rgba(15, 20, 30, 0.95) 50%,
          rgba(20, 25, 35, 0.96) 100%);
        border: 1px solid rgba(30, 35, 45, 0.4);
        border-radius: 16px;
        color: #F8FAFC;
        box-shadow: 
          0 0 15px rgba(11, 13, 23, 0.3),
          inset 0 1px 0 rgba(248, 250, 252, 0.05);
        transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
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


      #window {
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

      #clock {
        background: linear-gradient(135deg, 
          rgba(35, 40, 55, 0.9) 0%,
          rgba(30, 35, 50, 0.8) 50%,
          rgba(25, 30, 45, 0.85) 100%);
        border: 1px solid rgba(45, 50, 65, 0.4);
        border-radius: 12px;
        margin: 6px 10px;
        padding: 6px 18px;
        color: #E2E8F0;
        font-weight: 800;
        font-size: 14px;
        box-shadow: 
          0 0 12px rgba(25, 30, 40, 0.3),
          inset 0 1px 0 rgba(248, 250, 252, 0.08);
      }

      #cpu,
      #memory,
      #network,
      #pulseaudio,
      #tray {
        background: linear-gradient(135deg, 
          rgba(11, 13, 23, 0.85) 0%,
          rgba(18, 22, 30, 0.8) 100%);
        border: 1px solid rgba(25, 30, 40, 0.3);
        border-radius: 10px;
        margin: 6px 3px;
        padding: 6px 12px;
        color: #F8FAFC;
        font-weight: 600;
        transition: all 0.3s ease;
        box-shadow: 0 2px 8px rgba(11, 13, 23, 0.25);
      }

      #cpu {
        color: #10B981;
        border-color: rgba(16, 185, 129, 0.3);
      }

      #cpu:hover {
        background: linear-gradient(135deg, 
          rgba(16, 185, 129, 0.1) 0%,
          rgba(20, 25, 35, 0.8) 100%);
        box-shadow: 0 0 10px rgba(16, 185, 129, 0.2);
      }

      #memory {
        color: #F97316;
        border-color: rgba(249, 115, 22, 0.2);
      }

      #memory:hover {
        background: linear-gradient(135deg, 
          rgba(249, 115, 22, 0.1) 0%,
          rgba(20, 25, 35, 0.8) 100%);
        box-shadow: 0 0 10px rgba(249, 115, 22, 0.2);
      }

      #network {
        color: #06B6D4;
        border-color: rgba(6, 182, 212, 0.2);
      }

      #network:hover {
        background: linear-gradient(135deg, 
          rgba(6, 182, 212, 0.1) 0%,
          rgba(20, 25, 35, 0.8) 100%);
        box-shadow: 0 0 10px rgba(6, 182, 212, 0.2);
      }

      #pulseaudio {
        color: #8B5CF6;
        border-color: rgba(139, 92, 246, 0.2);
      }

      #pulseaudio:hover {
        background: linear-gradient(135deg, 
          rgba(139, 92, 246, 0.1) 0%,
          rgba(20, 25, 35, 0.8) 100%);
        box-shadow: 0 0 10px rgba(139, 92, 246, 0.2);
      }

      #tray {
        padding: 6px 10px;
        border-color: rgba(248, 250, 252, 0.2);
      }

      #tray:hover {
        background: linear-gradient(135deg, 
          rgba(248, 250, 252, 0.05) 0%,
          rgba(20, 25, 35, 0.8) 100%);
        box-shadow: 0 0 8px rgba(248, 250, 252, 0.1);
      }

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