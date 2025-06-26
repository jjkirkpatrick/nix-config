{ pkgs, ... }:
{
  programs.wlogout = {
    enable = true;
    layout = [
      {
        label = "lock";
        action = "hyprlock";
        text = "Lock";
        keybind = "l";
      }
      {
        label = "hibernate";
        action = "systemctl hibernate";
        text = "Hibernate";
        keybind = "h";
      }
      {
        label = "logout";
        action = "hyprctl dispatch exit";
        text = "Logout";
        keybind = "e";
      }
      {
        label = "shutdown";
        action = "systemctl poweroff";
        text = "Shutdown";
        keybind = "s";
      }
      {
        label = "suspend";
        action = "systemctl suspend";
        text = "Suspend";
        keybind = "u";
      }
      {
        label = "reboot";
        action = "systemctl reboot";
        text = "Reboot";
        keybind = "r";
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
        background-image: none;
        box-shadow: none;
      }

      window {
        background-color: #0B0D17;
      }

      button {
        color: #F8FAFC;
        background-color: #1A1F2E;
        border: 2px solid #252A38;
        border-radius: 16px;
        background-repeat: no-repeat;
        background-position: center;
        background-size: 25%;
        font-family: "JetBrains Mono Nerd Font", sans-serif;
        font-size: 14px;
        font-weight: 600;
        margin: 10px;
        transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
        box-shadow: 0 4px 15px #131820;
      }

      button:focus, button:active, button:hover {
        color: #0B0D17;
        background-color: #8B5CF6;
        border: 2px solid #8B5CF6;
        background-size: 30%;
        box-shadow: 0 8px 25px #8B5CF6;
        transform: translateY(-2px);
      }

      button:hover#lock {
        background-color: #10B981;
        border-color: #10B981;
        box-shadow: 0 8px 25px #10B981;
      }

      button:hover#logout {
        background-color: #06B6D4;
        border-color: #06B6D4;
        box-shadow: 0 8px 25px #06B6D4;
      }

      button:hover#shutdown {
        background-color: #F97316;
        border-color: #F97316;
        box-shadow: 0 8px 25px #F97316;
      }

      button:hover#reboot {
        background-color: #F97316;
        border-color: #F97316;
        box-shadow: 0 8px 25px #F97316;
      }

      button:hover#suspend {
        background-color: #8B5CF6;
        border-color: #8B5CF6;
        box-shadow: 0 8px 25px #8B5CF6;
      }

      button:hover#hibernate {
        background-color: #8B5CF6;
        border-color: #8B5CF6;
        box-shadow: 0 8px 25px #8B5CF6;
      }

      /* Button icons using CSS */
      #lock {
        background-image: image(url("${pkgs.wlogout}/share/wlogout/icons/lock.png"));
      }

      #logout {
        background-image: image(url("${pkgs.wlogout}/share/wlogout/icons/logout.png"));
      }

      #suspend {
        background-image: image(url("${pkgs.wlogout}/share/wlogout/icons/suspend.png"));
      }

      #hibernate {
        background-image: image(url("${pkgs.wlogout}/share/wlogout/icons/hibernate.png"));
      }

      #shutdown {
        background-image: image(url("${pkgs.wlogout}/share/wlogout/icons/shutdown.png"));
      }

      #reboot {
        background-image: image(url("${pkgs.wlogout}/share/wlogout/icons/reboot.png"));
      }
    '';
  };
}