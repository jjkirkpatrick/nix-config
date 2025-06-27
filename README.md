# NixOS + Hyprland Configuration (Dark Space Theme)

![NixOS Hyprland Desktop](./wallpapers/space.png)

> A comprehensive, production-ready NixOS configuration featuring Hyprland compositor with the Dark Space theme system, modern CLI tools, and extensive documentation.

> ⚠ **WARNING!** Make sure to configure WiFi secrets by copying `wireless-secrets.example` to `/etc/nixos/wireless-secrets` and adding your network passwords.

> ⚠ **WARNING!** Update [hardware-configuration.nix](./hosts/blue-pc/hardware-configuration.nix) according to your hardware or generate a new one via `nixos-generate-config --root /mnt` during installation.

> ⚠ **WARNING!** Review and modify user-specific paths in [home manager configuration](./modules/home/) to match your setup.

> ⚠ **WARNING!** This configuration includes NVIDIA drivers and gaming optimizations. Adjust [nvidia.nix](./modules/core/nvidia.nix) and [steam.nix](./modules/core/steam.nix) based on your hardware.

> ⚠ **WARNING!** The configuration uses experimental Nix features (flakes) and unstable nixpkgs. Some packages may occasionally break.

## Table Of Contents

- ℹ [About](#-about)
- 🎨 [Theme System](#-theme-system)
- 🔧 [Components](#-components)
- 📦 [Package Collections](#-package-collections)
- ⌨ [Keybindings](#-keybindings)
- 🚀 [Installation](#-installation)
- 🔧 [Configuration](#-configuration)
- 📝 [NixOS Specific Aliases](#-nixos-specific-aliases)
- 🛠 [Maintenance](#-maintenance)
- 📖 [License](#-license)

## ℹ About

This repository houses a comprehensive NixOS configuration designed for developers and power users. It features a modern Wayland-based desktop environment with Hyprland compositor, extensive theming system, and a curated collection of productivity tools.

**Key Features:**
- **Fully declarative configuration** using Nix flakes
- **Modular architecture** with clean separation of concerns
- **Comprehensive documentation** with inline comments explaining every option
- **Dark Space theme system** with consistent visual design
- **Modern CLI tools** replacing traditional Unix utilities
- **Development environment** with multiple programming languages
- **Gaming optimizations** with Steam and performance tweaks
- **Security-focused** with proper secrets management
- **Production-ready** with extensive testing and validation

**Configuration Highlights:**
- 45+ documented .nix configuration files
- 400+ packages with detailed explanations
- Advanced ZSH configuration with modern plugins
- Comprehensive audio setup (PipeWire replacing PulseAudio + ALSA + USB interfaces)
- Extensive Wayland integration
- Theme system supporting easy customization

## 🎨 Theme System

The configuration features a centralized **Dark Space** theme system inspired by cosmic aesthetics:

- **Consistent color palette** across all applications
- **Transparency and glass effects** in notifications and UI elements
- **Space-themed wallpapers** and visual elements
- **Modern typography** with JetBrains Mono Nerd Font
- **Customizable accent colors** for different contexts
- **Easy theme switching** through centralized configuration

### Color Palette
- **Primary Background**: Deep space (`#0B0D17`)
- **Surface Background**: Dark slate (`#1A1F2E`) 
- **Text Colors**: Star white (`#F8FAFC`) to muted gray
- **Accent Colors**: Cosmic cyan, nebula purple, stellar green
- **Transparency**: Multiple alpha levels for glass effects

## 🔧 Components

| Component        | Version/Name                          | Purpose                           |
| ---------------- | ------------------------------------- | --------------------------------- |
| **System**       |                                       |                                   |
| Distro           | NixOS (unstable)                      | Declarative Linux distribution    |
| Init System      | systemd                               | Service and process management    |
| Bootloader       | systemd-boot (UEFI)                   | Modern UEFI boot manager         |
| **Desktop**      |                                       |                                   |
| Display Server   | Wayland                               | Modern display protocol           |
| Compositor       | Hyprland                              | Dynamic tiling Wayland compositor |
| Display Manager  | SDDM (Astronaut theme)                | Login manager with custom theme   |
| Status Bar       | Waybar                                | Highly customizable status bar    |
| Notifications    | Mako                                  | Lightweight notification daemon   |
| App Launcher     | Wofi                                  | Application launcher for Wayland  |
| **Terminal**     |                                       |                                   |
| Shell            | Zsh + Powerlevel10k                   | Feature-rich shell with theming  |
| Terminal         | Kitty                                 | GPU-accelerated terminal emulator |
| **Development**  |                                       |                                   |
| Code Editor      | Cursor                                | AI VS Code                         |
| Version Control  | Git + Lazygit                         | Version control with TUI         |
| **Utilities**    |                                       |                                   |
| File Manager     | Nemo                                  | Feature-rich file manager        |
| Image Viewer     | Viewnior                              | Lightweight image viewer         |
| Web Browser      | Brave                                 | Privacy-focused browser           |
| **Media**        |                                       |                                   |
| Audio System     | PipeWire (replaces PulseAudio)        | Modern low-latency audio server  |
| Media Player     | VLC + MPV                             | Versatile media players          |
| Music Player     | Spotify + Termusic                    | Streaming and local music        |
| **Gaming**       |                                       |                                   |
| Gaming Platform  | Steam + Lutris                        | Game distribution and management  |
| Game Optimization| GameMode                              | Performance optimization daemon   |
| **Security**     |                                       |                                   |
| Password Manager | Bitwarden + pass                      | Secure password storage          |
| Screen Lock      | Swaylock-effects                      | Secure screen locking            |
| Idle Management  | Swayidle                              | Automatic power management       |
| **Virtualization**|                                      |                                   |
| Containers       | Podman                                | Rootless container runtime       |
| Virtual Machines | QEMU + virt-manager                   | System virtualization            |

## 📦 Package Collections

### CLI Tools (Modern Unix Replacements)
- **ripgrep** (`rg`) - Faster grep with better defaults
- **fd** - Modern find replacement with intuitive syntax
- **eza** - Enhanced ls with icons and git integration
- **bat** - Syntax-highlighted cat with paging
- **zoxide** - Smart cd that learns your habits
- **fzf** - Fuzzy finder for interactive filtering
- **btop** - Modern system monitor with mouse support
- **delta** - Enhanced git diff viewer

### Development Environment
- **Languages**: Python, Node.js, Rust, Go, C/C++
- **Tools**: Docker, Git, GitHub CLI, jq, yq
- **Editors**: (full IDE setup), Cursor   
- **Debugging**: GDB, Valgrind for C/C++
- **Databases**: SQLite for development

### Multimedia & Creativity
- **Video**: VLC, MPV, FFmpeg
- **Images**: Viewnior, ImageMagick
- **Audio**: PipeWire (replaces PulseAudio), pavucontrol, audio routing
- **Screenshots**: Grim, Slurp, Swappy

## ⌨ Keybindings

### Window Management
| Key Combination           | Action                                    |
| ------------------------- | ----------------------------------------- |
| `SUPER + H,J,K,L`         | Move focus between windows               |
| `SUPER + SHIFT + H,J,K,L` | Move windows in workspace                |
| `SUPER + CTRL + H,J,K,L`  | Resize active window                     |
| `SUPER + ALT + H,J,K,L`   | Move active window position              |
| `SUPER + 1-9,0`           | Switch to workspace 1-10                |
| `SUPER + SHIFT + 1-9,0`   | Move window to workspace 1-10 (silent)  |
| `SUPER + CTRL + C`        | Move window to empty workspace           |
| `SUPER + X`               | Toggle window split orientation          |
| `SUPER + F`               | Toggle fullscreen                        |
| `SUPER + SHIFT + F`       | Toggle maximize                          |
| `SUPER + Space`           | Toggle floating mode                     |
| `SUPER + P`               | Toggle pseudo-tiling                     |
| `SUPER + Q`               | Close active window                      |

### Application Shortcuts
| Key Combination           | Action                                    |
| ------------------------- | ----------------------------------------- |
| `SUPER + Return`          | Launch Kitty terminal                    |
| `ALT + Return`            | Launch floating Kitty terminal           |
| `SUPER + SHIFT + Return`  | Launch fullscreen Kitty terminal         |
| `SUPER + R`               | Launch Wofi application launcher         |
| `SUPER + E`               | Launch Nemo file manager                 |
| `ALT + E`                 | Launch floating Nemo file manager        |
| `SUPER + B`               | Launch Brave browser (workspace 1)       |
| `SUPER + SHIFT + D`       | Launch Discord                           |
| `SUPER + V`               | Open clipboard history with Wofi         |

### System Controls
| Key Combination           | Action                                    |
| ------------------------- | ----------------------------------------- |
| `SUPER + Escape`          | Lock screen with Swaylock               |
| `ALT + Escape`            | Lock screen with Swaylock               |
| `SUPER + SHIFT + Escape`  | Launch Wlogout menu                      |
| `CTRL + SHIFT + Escape`   | Launch Mission Center (workspace 9)      |
| `SUPER + SHIFT + B`       | Toggle Waybar                            |
| `SUPER + N`               | Dismiss notifications                    |
| `Print`                   | Screenshot to clipboard                  |
| `SUPER + Print`           | Screenshot to file                       |
| `SUPER + SHIFT + Print`   | Screenshot area with Swappy              |

### Audio & Media
| Key Combination           | Action                                    |
| ------------------------- | ----------------------------------------- |
| `XF86AudioRaiseVolume`    | Increase volume                          |
| `XF86AudioLowerVolume`    | Decrease volume                          |
| `XF86AudioMute`           | Toggle mute                              |
| `XF86AudioPlay`           | Play/pause media                         |
| `XF86AudioNext`           | Next track                               |
| `XF86AudioPrev`           | Previous track                           |

> Complete keybindings available in [hypr/bind.conf](./modules/home/config/hypr/bind.conf)

## 🚀 Installation

### Prerequisites
- NixOS 24.11 or newer (or NixOS unstable)
- Git installed
- Internet connection for package downloads

### Quick Installation

1. **Clone the repository:**
   ```bash
   git clone https://github.com/jjkirkpatrick/nix-config.git
   cd nix-config
   ```

2. **Configure WiFi secrets:**
   ```bash
   sudo cp wireless-secrets.example /etc/nixos/wireless-secrets
   sudo nano /etc/nixos/wireless-secrets  # Add your WiFi password
   sudo chmod 600 /etc/nixos/wireless-secrets
   ```

3. **Generate hardware configuration:**
   ```bash
   sudo nixos-generate-config --root /mnt --show-hardware-config > hosts/your-hostname/hardware-configuration.nix
   ```

4. **Update flake.nix:**
   ```bash
   # Add your hostname to nixosConfigurations in flake.nix
   # Update username if different from "josh"
   ```

5. **Build and switch:**
   ```bash
   sudo nixos-rebuild switch --flake .#your-hostname
   ```

6. **Apply home-manager configuration:**
   ```bash
   home-manager switch --flake .#your-username
   ```

### Automated Installation Script

Use the provided installation script for guided setup:

```bash
./install.sh --setup-wifi
```

The script provides:
- Interactive configuration prompts
- WiFi setup assistance
- Host configuration creation
- Validation and error checking
- Dry-run option for testing

## 🔧 Configuration

### Adding New Hosts

1. Create host directory: `mkdir hosts/new-hostname`
2. Add `default.nix` and `hardware-configuration.nix`
3. Update `flake.nix` to include the new host
4. Run `nixos-rebuild switch --flake .#new-hostname`

### Customizing the Theme

1. Edit colors in `modules/home/themes/dark-space/colors.nix`
2. Modify application themes in respective config files
3. Rebuild with `home-manager switch --flake .#username`

### Managing Packages

- **System packages**: Edit `modules/home/packages/cli.nix` or `gui.nix`
- **Development tools**: Modify `modules/home/development.nix`
- **Core system**: Update relevant files in `modules/core/`

## 📝 NixOS Specific Aliases

Convenient aliases for NixOS management:

| Alias              | Command                                        | Purpose                           |
| ------------------ | ---------------------------------------------- | --------------------------------- |
| `rebuild`          | `sudo nixos-rebuild switch --flake .`         | Rebuild system configuration     |
| `fullRebuild`      | `rebuild && home-manager switch --flake .`    | Rebuild system + home-manager    |
| `homeRebuild`      | `home-manager switch --flake .`               | Rebuild only home-manager        |
| `fullClean`        | `sudo nix-collect-garbage -d`                 | Clean old generations            |
| `nixClean`         | `nix-collect-garbage -d`                      | Clean user profile garbage       |
| `listGens`         | `sudo nix-env --list-generations --profile /nix/var/nix/profiles/system` | List system generations |
| `flakeUpdate`      | `nix flake update`                             | Update flake inputs              |
| `nixSearch`        | `nix search nixpkgs`                          | Search for packages              |
| `nixShell`         | `nix shell nixpkgs#`                          | Temporary package installation   |

## 🛠 Maintenance

### Regular Maintenance Tasks

1. **Update the system:**
   ```bash
   flakeUpdate && fullRebuild
   ```

2. **Clean old generations:**
   ```bash
   fullClean
   ```

3. **Check system status:**
   ```bash
   nixos-rebuild dry-run --flake .
   ```

4. **Verify configuration:**
   ```bash
   nix flake check
   ```

### Backup Important Data

The configuration includes automated backup recommendations for:
- SSH keys (`~/.ssh/`)
- GPG keys (`~/.gnupg/`)
- Browser profiles and bookmarks
- Custom scripts and dotfiles

### Troubleshooting

- **Boot issues**: Use GRUB menu to select previous generation
- **Package conflicts**: Run `nix flake check` to validate configuration
- **Performance issues**: Check `btop` or `htop` for resource usage
- **Audio problems**: Restart PipeWire with `systemctl --user restart pipewire pipewire-pulse`

## 📖 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

## 🤝 Contributing

Contributions are welcome! Please:

1. Fork the repository
2. Create a feature branch
3. Make your changes with proper documentation
4. Test the configuration thoroughly
5. Submit a pull request

## 🙏 Acknowledgments

- **NixOS Community** - For the amazing declarative OS
- **Hyprland** - For the fantastic Wayland compositor  
- **Catppuccin** - For the beautiful color schemes that inspired Dark Space
- **All package maintainers** - For keeping the ecosystem alive

---

**Last Updated**: 2025-06-27  
**NixOS Version**: Unstable (25.05)  
**Configuration Version**: 2.0.0