{ config, lib, pkgs, modulesPath, ... }:

let
  vars = import ./custom_vars.nix;
in
{
  imports = [
    # =========================================================================
    # POLICIES (Essential Structural Choices - Choose ONE per category)
    # =========================================================================

    # ---- Bootloader ---------------------------------------------------------
    ./genoc/policies/boot/grub.nix               # Standard GRUB2 bootloader
    # ./genoc/policies/boot/systemd-boot.nix     # Modern systemd-boot (UEFI only)
    # ./genoc/policies/boot/grub-dualboot-efi.nix # GRUB with Windows dual-boot support
    ./genoc/policies/boot/plymouth.nix           # Modern boot splash screen (visual boot)

    # ---- Desktop Environment (Main Graphical Interface) ---------------------
    ./genoc/policies/desktop/kde/plasma.nix      # KDE Plasma 6 Desktop Environment
    # ./genoc/policies/desktop/gnome/shell.nix   # GNOME Desktop Environment
    # ./genoc/policies/desktop/tilling/hyprland.nix # Hyprland (Wayland compositor)
    # ./genoc/policies/desktop/tilling/sway.nix # Sway (Wayland i3-compatible)
    # ./genoc/policies/desktop/tilling/i3.nix   # i3 Window Manager (X11)
    # ./genoc/policies/desktop/hybrid/rich-kde-primary.nix # KDE + GNOME (KDE primary)
    # ./genoc/policies/desktop/hybrid/lightweight-xfce-primary.nix # XFCE + others

    # ---- Power Management ---------------------------------------------------
    ./genoc/policies/power/cpu/balance.nix       # Balanced CPU power/performance policy
    # ./genoc/policies/power/cpu/performance.nix # Maximum CPU performance (fixed high freq)
    # ./genoc/policies/power/cpu/eco-ultra.nix   # Extreme energy saving for battery longevity

    # ---- Networking & Firewall ----------------------------------------------
    ./genoc/policies/networking/firewall/base.nix # Standard protective firewall (enabled)
    # ./genoc/policies/networking/firewall/stealth.nix # Stealth firewall (drops ICMP/pings)
    # ./genoc/policies/networking/firewall/open.nix # Completely open firewall (risky!)
    
    # ---- Firewall Port Openers (Expose services to network) -----------------
    # ./genoc/policies/networking/firewall/open-web.nix # Open HTTP/HTTPS (80/443)
    # ./genoc/policies/networking/firewall/open-p2p-crypto.nix # Open Bitcoin/Elements (8333/17041)
    # ./genoc/policies/networking/firewall/open-syncthing.nix # Open Syncthing (22000/21027)
    # ./genoc/policies/networking/firewall/open-home-automation.nix # Open HA/Zigbee ports
    # ./genoc/policies/networking/firewall/open-ai-ollama.nix # Open Ollama API (11434)
    # ./genoc/policies/networking/firewall/open-gaming.nix # Open Minecraft (25565)

    # ---- SSH Access ---------------------------------------------------------
    ./genoc/policies/networking/ssh/hardened.nix # Public Key ONLY (Secure standard)
    # ./genoc/policies/networking/ssh/base.nix     # Password and Key (Balanced)
    # ./genoc/policies/networking/ssh/paranoid.nix # Requires BOTH Key and Password (MFA)

    # ---- System Policies ----------------------------------------------------
    ./genoc/policies/security/sudo/wheel-no-password.nix # Allow sudo without password
    ./genoc/policies/security/polkit/base.nix    # Basic GUI authorization support
    ./genoc/policies/security/gpg/agent.nix      # GPG agent with SSH support
    ./genoc/policies/system/shells/zsh.nix       # Zsh shell with modern defaults
    # ./genoc/policies/system/shells/bash.nix     # Classic Bash shell

    # =========================================================================
    # PROFILES (Mixins - Add as many as you want)
    # =========================================================================

    # ---- Development Profiles -----------------------------------------------
    ./genoc/profiles/development/backend-go-god.nix # The ultimate Go/Crypto backend stack
    # ./genoc/profiles/development/fullstack-god.nix # Fullstack development environment
    # ./genoc/profiles/development/dev-hacker.nix   # Minimalist hacker-oriented tools
    # ./genoc/profiles/development/backend-rust.nix # Rust developer environment
    # ./genoc/profiles/development/backend-go.nix   # Standard Go developer environment
    # ./genoc/profiles/development/web-frontend.nix # Modern web frontend tools
    # ./genoc/profiles/development/data-scientist.nix # Data science and ML stack
    # ./genoc/profiles/development/dev-newbie.nix   # Beginner-friendly dev tools
    # ./genoc/profiles/development/devops-engineer.nix # Infrastructure and DevOps tools
    # ./genoc/profiles/development/game-engine-dev.nix # Game engine development stack
    # ./genoc/profiles/development/mobile-app-dev.nix # Android and Flutter development
    # ./genoc/profiles/development/embedded-engineer.nix # Embedded systems and firmware tools

    # ---- Business & Office --------------------------------------------------
    # ./genoc/profiles/business/office-rat.nix      # Standard office productivity suite
    # ./genoc/profiles/business/office-light-eco.nix # Minimalist and efficient office tools
    # ./genoc/profiles/business/academic-researcher.nix # Academic research and writing tools
    # ./genoc/profiles/business/doc-hacker.nix      # LaTeX and advanced document tools
    # ./genoc/profiles/business/finance-guru.nix    # Advanced finance and analysis tools
    # ./genoc/profiles/business/finance-retail.nix  # Basic finance and banking tools
    # ./genoc/profiles/business/legal-prof.nix      # Tools for legal professionals
    # ./genoc/profiles/business/student.nix         # Essential tools for students
    # ./genoc/profiles/business/trader-pro.nix      # Professional trading and market analysis

    # ---- Security & Privacy -------------------------------------------------
    # ./genoc/profiles/security/privacy-paranoid.nix # Maximum privacy and anonymity tools
    # ./genoc/profiles/security/red-team.nix        # Pentesting and offensive security
    # ./genoc/profiles/security/forensic-analyst.nix # Digital forensics and investigation
    # ./genoc/profiles/security/osint-investigator.nix # Open-source intelligence tools

    # ---- Creative & Multimedia ----------------------------------------------
    # ./genoc/profiles/creative/digital-artist.nix  # 2D/3D digital art and illustration
    # ./genoc/profiles/creative/music-producer.nix  # Digital audio workstation tools
    # ./genoc/profiles/creative/photographer.nix    # Photography and editing workflow
    # ./genoc/profiles/creative/streamer.nix        # Live streaming and content creation
    # ./genoc/profiles/creative/vector-designer.nix # Vector graphics and design tools
    # ./genoc/profiles/creative/vfx-astronaut.nix   # Visual effects and 3D animation
    # ./genoc/profiles/creative/ricing-god.nix      # Deep system UI customization tools

    # ---- Gaming -------------------------------------------------------------
    # ./genoc/profiles/gaming/steam-heavy.nix       # Optimized Steam gaming environment
    # ./genoc/profiles/gaming/retro-maniac.nix      # Emulators and retro gaming tools
    # ./genoc/profiles/gaming/simulation-rig.nix    # Optimized for heavy simulation games
    # ./genoc/profiles/gaming/minecraft-server.nix  # Local Minecraft server setup

    # ---- Social & Communication ---------------------------------------------
    # ./genoc/profiles/social/chatterbox-god.nix    # All major communication apps
    # ./genoc/profiles/social/irc-veteran.nix       # IRC clients and classic chat tools
    # ./genoc/profiles/social/minimalist.nix        # Minimalist communication tools

    # ---- Web Browsing -------------------------------------------------------
    # ./genoc/profiles/web/hacker.nix               # Hardened and dev-oriented browsers
    # ./genoc/profiles/web/hoarder.nix              # Web archiving and heavy browsing
    # ./genoc/profiles/web/surfer.nix               # Lightweight and fast browsing

    # ---- System Behavior ----------------------------------------------------
    # ./genoc/profiles/system/minimal-server.nix    # Minimal server configuration
    # ./genoc/profiles/system/kiosk-mode.nix        # Full-screen kiosk for public displays
    # ./genoc/profiles/system/parental-control.nix  # Content filtering and restrictions
    # ./genoc/profiles/system/behavior/prevent-sleep.nix # Disables automatic sleep
    # ./genoc/profiles/system/behavior/prevent-hibernation.nix # Disables hibernation
    # ./genoc/profiles/system/behavior/server-uptime.nix # Optimized for long uptime
  ];

  # =========================================================================
  # SPECIALISATIONS (Switch contexts on the fly at boot or via switch)
  # =========================================================================
  specialisation = {

    # ---- REGULAR DEV: The God Stack with full networking --------------------
    dev.configuration = {
      system.nixos.tags = [ "backend-go-god" ];
      imports = [
        ./genoc/profiles/development/backend-go-god.nix
        ./genoc/modules/infrastructure/networking/syncthing.nix
        ./genoc/policies/networking/firewall/open-p2p-crypto.nix
        ./genoc/policies/networking/firewall/open-syncthing.nix
      ];
    };

    # ---- TEXT MODE GOD: No GUI, All CLI Tools and Zsh -----------------------
    headless.configuration = {
      system.nixos.tags = [ "terminal-only" ];
      imports = [
        ./genoc/profiles/system/minimal-server.nix
        ./genoc/profiles/development/dev-hacker.nix
        ./genoc/policies/system/shells/zsh.nix
      ];
      services.xserver.enable = lib.mkForce false;
      services.displayManager.sddm.enable = lib.mkForce false;
    };

    # ---- OFFICE MANIAC: LaTeX God and heavy document tools ------------------
    office.configuration = {
      system.nixos.tags = [ "office-maniac" ];
      imports = [
        ./genoc/profiles/business/office-rat.nix
      ];
      environment.systemPackages = with pkgs; [
        texlive.combined.scheme-full # The complete LaTeX scheme (5GB+)
        pandoc                       # Universal document converter
      ];
    };

    # ---- THEATER MODE: Multimedia focus, stay awake -------------------------
    theater.configuration = {
      system.nixos.tags = [ "theater-mode" ];
      imports = [
        ./genoc/profiles/system/behavior/prevent-sleep.nix
        ./genoc/modules/domains/multimedia/vlc.nix
        ./genoc/modules/domains/multimedia/codecs.nix
      ];
    };

    # ---- SHOPPING EMERGENCY: Max battery, Nvidia OFF, Eco CPU ---------------
    shopping.configuration = {
      system.nixos.tags = [ "shopping-emergency" ];
      imports = [
        ./genoc/policies/power/cpu/eco-ultra.nix
        ./genoc/policies/power/video/nvidia-offload.nix
        ./genoc/profiles/business/office-light-eco.nix
      ];
      networking.networkmanager.wifi.powersave = lib.mkForce true;
    };
  };

  # =========================================================================
  # EXTRA PACKAGES
  # =========================================================================
  environment.systemPackages = with pkgs; [
    # IMPORTANT: Avoid adding packages directly here. 
    # Try to find/create a Profile or Module instead for better organization.
  ];

  # ---- System Version (DO NOT CHANGE) ---------------------------------------
  system.stateVersion = vars.installationNixOSVersion;
}