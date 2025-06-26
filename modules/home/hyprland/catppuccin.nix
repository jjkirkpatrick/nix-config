{ ... }:
{
  # Enable Catppuccin theme for Hyprland, Hyprlock, Rofi, and Waybar
  catppuccin = {
    enable = true;
    flavor = "mocha"; # Options: latte, frappe, macchiato, mocha
    accent = "mauve"; # Options: rosewater, flamingo, pink, mauve, red, maroon, peach, yellow, green, teal, sky, sapphire, blue, lavender
    
    # Enable Catppuccin for specific applications
    hyprland.enable = true;
    hyprlock.enable = true;
    rofi.enable = true;
    waybar.enable = true;
  };
}