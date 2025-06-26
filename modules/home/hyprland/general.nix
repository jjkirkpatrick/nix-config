{ ... }:
{
  wayland.windowManager.hyprland.settings = {
    general = {
      layout = "dwindle";
      gaps_in = 6;
      gaps_out = 12;
      border_size = 2;
      # Dark Space theme colors
      "col.active_border" = "rgb(8B5CF6) rgb(06B6D4) 45deg"; # Purple to cyan gradient
      "col.inactive_border" = "rgba(252a38b3)"; # Cosmic gray
      # border_part_of_window = false;
      no_border_on_floating = false;
    };

    misc = {
      disable_autoreload = true;
      disable_hyprland_logo = true;
      always_follow_on_dnd = true;
      layers_hog_keyboard_focus = true;
      animate_manual_resizes = false;
      enable_swallow = true;
      focus_on_activate = true;
      new_window_takes_over_fullscreen = 2;
      middle_click_paste = false;
    };

    dwindle = {
      force_split = 2;
      special_scale_factor = 1.0;
      split_width_multiplier = 1.0;
      use_active_for_splits = true;
      pseudotile = "yes";
      preserve_split = "yes";
    };

    master = {
      new_status = "master";
      special_scale_factor = 1;
    };
  };
}