{ pkgs, lib, ... }:
let
  # Current active theme - change this to switch themes
  currentTheme = "dark-space";
  
  # Import the selected theme
  theme = import ./${currentTheme} { inherit lib; };
in
{
  # Export theme for other modules to use
  _module.args.theme = theme;
  
  # You can add theme-specific module imports here if needed
  # imports = [
  #   ./${currentTheme}/module-overrides.nix  # Optional theme-specific overrides
  # ];
  
  # Global theme configuration that applies to all modules
  config = {
    # You can add global theme settings here
    # For example, setting a global color scheme variable
    # home.sessionVariables.THEME_NAME = currentTheme;
  };
}