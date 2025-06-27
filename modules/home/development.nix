# ======================================================================
# DEVELOPMENT ENVIRONMENT CONFIGURATION
# ======================================================================
# This module configures a comprehensive development environment with
# programming languages, development tools, version control, and utilities
# needed for software development across multiple languages and platforms.
#
# Includes toolchains for popular languages (Python, JavaScript, Rust, Go,
# C/C++) as well as essential development utilities for a productive workflow.
# ======================================================================

{ config, pkgs, ... }:
{
  # ============================================================
  # DEVELOPMENT PACKAGES
  # ============================================================
  # Install essential development tools and programming language toolchains
  
  home.packages = with pkgs; [
    # ========================================
    # Python Development Environment
    # ========================================
    python3                           # Python 3 interpreter - latest stable version
    python3Packages.pip              # Python package installer
    python3Packages.virtualenv       # Virtual environment management for Python projects
    python3Packages.requests         # Popular HTTP library for Python

    # ========================================
    # JavaScript/Node.js Development
    # ========================================
    nodejs                           # Node.js runtime for JavaScript development
    yarn                             # Alternative package manager for Node.js (faster than npm)

    # ========================================
    # Rust Development Toolchain
    # ========================================
    rustc                            # Rust compiler - systems programming language
    cargo                            # Rust package manager and build tool
    rustfmt                          # Code formatter for Rust - maintains consistent style
    clippy                           # Rust linter - catches common mistakes and improves code quality

    # ========================================
    # Go Development Environment
    # ========================================
    go                               # Go programming language - efficient and concurrent

    # ========================================
    # C/C++ Development Tools
    # ========================================
    gcc                              # GNU Compiler Collection - C/C++ compiler
    gdb                              # GNU Debugger - debugging C/C++ applications
    valgrind                         # Memory error detector and profiler for C/C++
    cmake                            # Cross-platform build system generator

    # ========================================
    # Essential Development Utilities
    # ========================================
    git                              # Distributed version control system
    curl                             # Command-line HTTP client - API testing and downloads
    wget                             # Non-interactive network downloader
    jq                               # JSON processor - parsing and manipulating JSON data
    tree                             # Directory structure visualization
    htop                             # Interactive process viewer - system monitoring
    neofetch                         # System information display tool
    unzip                            # Archive extraction utility
    zip                              # Archive creation utility

    # ========================================
    # Text Editors and Development Environments
    # ========================================
    vim                              # Classic text editor - always available

    # ========================================
    # Container and Deployment Tools
    # ========================================
    docker                           # Container runtime - application packaging and deployment
    docker-compose                   # Multi-container Docker application orchestration

    # ========================================
    # Database Development Tools
    # ========================================
    sqlite                           # Lightweight embedded database - development and testing
    
    # ========================================
    # Version Control and Collaboration
    # ========================================
    gh                               # GitHub CLI - repository management and workflow automation
  ];

  # ============================================================
  # GIT CONFIGURATION
  # ============================================================
  # Configure Git with user information and preferences for version control
  # This ensures consistent commits across all repositories
  
  programs.git = {
    enable = true;                              # Enable Git through home-manager
    userName = "jjkirkpatrick";                 # Git commit author name
    userEmail = "joshkirkpatrick12@gmail.com";  # Git commit author email
    
    # Additional Git configuration can be added here:
    # - Aliases for common commands
    # - Default branch settings
    # - Merge/diff tool preferences
    # - Signing key configuration
  };
}