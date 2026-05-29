{ inputs, lib, pkgs, ... }:

let
  driftwm = inputs.driftwm.packages.${pkgs.system}.default;
  rosePineDawn = {
    base = "#faf4ed";
    surface = "#fffaf3";
    overlay = "#f2e9de";
    muted = "#9893a5";
    text = "#575279";
    love = "#b4637a";
    gold = "#ea9d34";
    rose = "#d7827e";
    pine = "#286983";
    foam = "#56949f";
    iris = "#907aa9";
  };
in
{
  services.displayManager.sessionPackages = [ driftwm ];

  systemd.user.services.driftwm = {
    path = with pkgs; [
      driftwm
      ghostty
      waybar
      crystal-dock
      fuzzel
      swaynotificationcenter
      swaylock
      xwayland-satellite
      grim
      slurp
      wl-clipboard
      brightnessctl
      playerctl
      pavucontrol
      blueman
      networkmanagerapplet
    ];
    serviceConfig.ExecStart = lib.mkForce "${driftwm}/bin/driftwm";
  };

  programs.xwayland.enable = true;
  services.dbus.enable = true;
  security.polkit.enable = true;
  services.gnome.gnome-keyring.enable = true;
  services.gvfs.enable = true;

  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-gtk
      xdg-desktop-portal-wlr
    ];
  };

  environment.systemPackages = with pkgs; [
    driftwm
    ghostty
    waybar
    crystal-dock
    fuzzel
    swaynotificationcenter
    swaylock
    swayidle
    xwayland-satellite
    grim
    slurp
    wl-clipboard
    wlr-randr
    wdisplays
    brightnessctl
    playerctl
    pavucontrol
    blueman
    networkmanagerapplet
    papirus-icon-theme
    adwaita-icon-theme
    adwaita-fonts
  ];

  fonts.packages = with pkgs; [
    adwaita-fonts
    nerd-fonts.jetbrains-mono
  ];

  home-manager.users.artem = { pkgs, ... }: {
    home.packages = with pkgs; [
      ghostty
      waybar
      crystal-dock
      fuzzel
      swaynotificationcenter
      swaylock
      swayidle
      xwayland-satellite
      grim
      slurp
      wl-clipboard
      wlr-randr
      wdisplays
      brightnessctl
      playerctl
      pavucontrol
      blueman
      networkmanagerapplet
      papirus-icon-theme
    ];

    xdg.configFile."driftwm/config.toml".text = ''
      mod_key = "super"
      focus_follows_mouse = false
      window_placement = "auto"

      autostart = [
        "systemctl --user import-environment WAYLAND_DISPLAY XDG_CURRENT_DESKTOP DISPLAY",
        "swaync",
        "waybar -c ~/.config/waybar-driftwm/config.jsonc -s ~/.config/waybar-driftwm/style.css",
        "crystal-dock",
        "nm-applet --indicator",
        "blueman-applet"
      ]

      [env]
      XDG_CURRENT_DESKTOP = "driftwm"
      XDG_SESSION_DESKTOP = "driftwm"
      NIXOS_OZONE_WL = "1"
      MOZ_ENABLE_WAYLAND = "1"
      QT_QPA_PLATFORM = "wayland;xcb"
      GDK_BACKEND = "wayland,x11"
      ELECTRON_OZONE_PLATFORM_HINT = "wayland"

      [input.keyboard]
      layout = "us,ru"
      options = "grp:alt_shift_toggle"

      [cursor]
      theme = "Adwaita"
      size = 24

      [navigation]
      friction = 0.955
      animation_speed = 0.28
      anchors = [[0, 0], [-1750, 1750], [1750, 1750], [1750, -1750], [-1750, -1750]]

      [snap]
      gap = 14.0
      distance = 28.0

      [decorations]
      bg_color = "${rosePineDawn.surface}"
      fg_color = "${rosePineDawn.text}"
      corner_radius = 14
      shadow = true
      default_mode = "client"
      border_width = 2
      border_color = "${rosePineDawn.overlay}"
      border_color_focused = "${rosePineDawn.rose}"

      [effects]
      blur_radius = 3
      blur_strength = 1.15

      [background]
      type = "shader"
      path = "~/.config/driftwm/rose-pine-dawn-grid.glsl"

      [keybindings]
      "mod+return" = "exec ghostty"
      "mod+d" = "exec fuzzel"
      "mod+shift+n" = "spawn swaync-client -t -sw"
      "mod+l" = "spawn swaylock -f -c faf4ed"
      "Print" = "spawn grim - | wl-copy"
      "shift+Print" = "spawn grim -g \"$(slurp -d)\" - | wl-copy"
      "XF86AudioRaiseVolume" = "spawn wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"
      "XF86AudioLowerVolume" = "spawn wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
      "XF86AudioMute" = "spawn wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
      "XF86MonBrightnessUp" = "spawn brightnessctl set +5%"
      "XF86MonBrightnessDown" = "spawn brightnessctl set 5%-"

      [[window_rules]]
      app_id = "com.mitchellh.ghostty"
      opacity = 0.88
      blur = true
      decoration = "minimal"
      border_color_focused = "${rosePineDawn.iris}"

      [[window_rules]]
      app_id = "ghostty"
      opacity = 0.88
      blur = true
      decoration = "minimal"
      border_color_focused = "${rosePineDawn.iris}"

      [[window_rules]]
      app_id = "waybar"
      widget = true
      decoration = "none"

      [[window_rules]]
      app_id = "swaync"
      opacity = 0.96
      blur = true
      decoration = "minimal"

      [[window_rules]]
      app_id = "crystal-dock"
      widget = true
      decoration = "none"
    '';

    xdg.configFile."driftwm/rose-pine-dawn-grid.glsl".text = ''
      precision mediump float;

      uniform vec2 u_resolution;
      uniform vec2 u_camera;
      uniform float u_zoom;
      uniform float u_time;

      float grid(vec2 p, float scale, float width) {
        vec2 q = abs(fract(p / scale - 0.5) - 0.5) / fwidth(p / scale);
        float line = min(q.x, q.y);
        return 1.0 - min(line / width, 1.0);
      }

      void main() {
        vec2 uv = gl_FragCoord.xy / u_resolution.xy;
        vec2 p = (gl_FragCoord.xy - 0.5 * u_resolution.xy) / max(u_zoom, 0.001) + u_camera;
        vec3 base = vec3(0.980, 0.957, 0.929);
        vec3 tint = mix(vec3(0.839, 0.510, 0.494), vec3(0.337, 0.580, 0.624), uv.x);
        float vignette = smoothstep(0.95, 0.15, distance(uv, vec2(0.48, 0.52)));
        float fine = grid(p, 48.0, 0.55) * 0.18;
        float major = grid(p, 384.0, 0.9) * 0.28;
        float wave = 0.5 + 0.5 * sin((p.x + p.y) * 0.0025 + u_time * 0.12);
        vec3 color = mix(base, tint, 0.08 + 0.06 * wave) - fine - major;
        color = mix(base * 0.94, color, vignette);
        gl_FragColor = vec4(color, 1.0);
      }
    '';

    xdg.configFile."waybar-driftwm/config.jsonc".text = ''
      {
        "layer": "top",
        "position": "top",
        "height": 34,
        "spacing": 8,
        "margin-top": 8,
        "margin-left": 12,
        "margin-right": 12,
        "modules-left": ["custom/launcher", "wlr/taskbar"],
        "modules-center": ["clock"],
        "modules-right": ["tray", "pulseaudio", "network", "battery", "custom/notifications"],
        "custom/launcher": {
          "format": " 󰣇 ",
          "on-click": "fuzzel"
        },
        "wlr/taskbar": {
          "format": "{icon}",
          "icon-size": 18,
          "tooltip-format": "{title}",
          "on-click": "activate",
          "on-click-middle": "close"
        },
        "clock": {
          "format": "{:%a %d %b  %H:%M}",
          "tooltip-format": "{:%Y-%m-%d}"
        },
        "tray": {
          "icon-size": 16,
          "spacing": 8
        },
        "pulseaudio": {
          "format": "{icon} {volume}%",
          "format-muted": "󰝟 muted",
          "format-icons": ["󰕿", "󰖀", "󰕾"],
          "on-click": "pavucontrol"
        },
        "network": {
          "format-wifi": "󰤨 {essid}",
          "format-ethernet": "󰈀 wired",
          "format-disconnected": "󰤭 offline",
          "on-click": "nm-connection-editor"
        },
        "battery": {
          "format": "{icon} {capacity}%",
          "format-icons": ["󰂎", "󰁺", "󰁻", "󰁼", "󰁽", "󰁾", "󰁿", "󰂀", "󰂁", "󰁹"]
        },
        "custom/notifications": {
          "format": "󰂚",
          "on-click": "swaync-client -t -sw",
          "tooltip": false
        }
      }
    '';

    xdg.configFile."waybar-driftwm/style.css".text = ''
      * {
        border: none;
        border-radius: 0;
        font-family: "JetBrainsMono Nerd Font", "Adwaita Sans", sans-serif;
        font-size: 13px;
        min-height: 0;
      }

      window#waybar {
        background: transparent;
        color: ${rosePineDawn.text};
      }

      #custom-launcher,
      #taskbar,
      #clock,
      #tray,
      #pulseaudio,
      #network,
      #battery,
      #custom-notifications {
        background: alpha(${rosePineDawn.surface}, 0.82);
        border: 1px solid alpha(${rosePineDawn.overlay}, 0.92);
        border-radius: 8px;
        box-shadow: 0 6px 24px alpha(${rosePineDawn.muted}, 0.18);
        margin: 0 2px;
        padding: 0 11px;
      }

      #custom-launcher {
        color: ${rosePineDawn.pine};
        padding: 0 13px;
      }

      #taskbar button {
        color: ${rosePineDawn.muted};
        border-radius: 6px;
        margin: 4px 2px;
        padding: 0 6px;
      }

      #taskbar button.active {
        background: alpha(${rosePineDawn.rose}, 0.20);
        color: ${rosePineDawn.love};
      }

      #clock {
        color: ${rosePineDawn.iris};
        font-weight: 700;
      }

      #pulseaudio {
        color: ${rosePineDawn.foam};
      }

      #network {
        color: ${rosePineDawn.pine};
      }

      #battery {
        color: ${rosePineDawn.gold};
      }

      #custom-notifications {
        color: ${rosePineDawn.love};
      }
    '';

    xdg.configFile."fuzzel/fuzzel.ini".text = ''
      font=JetBrainsMono Nerd Font:size=13
      icon-theme=Papirus
      width=44
      lines=12
      tabs=4
      horizontal-pad=18
      vertical-pad=14
      inner-pad=10
      image-size-ratio=0.35
      line-height=24

      [colors]
      background=faf4edf2
      text=575279ff
      match=d7827eff
      selection=f2e9deff
      selection-text=575279ff
      selection-match=b4637aff
      border=907aa9ff

      [border]
      width=2
      radius=8
    '';

    xdg.configFile."swaync/config.json".text = ''
      {
        "$schema": "/etc/xdg/swaync/configSchema.json",
        "positionX": "right",
        "positionY": "top",
        "layer": "overlay",
        "control-center-layer": "top",
        "control-center-width": 390,
        "control-center-height": 620,
        "notification-window-width": 380,
        "keyboard-shortcuts": true,
        "image-visibility": "when-available",
        "transition-time": 180,
        "hide-on-clear": true,
        "hide-on-action": true,
        "script-fail-notify": true,
        "widgets": ["title", "dnd", "notifications"]
      }
    '';

    xdg.configFile."swaync/style.css".text = ''
      * {
        font-family: "Adwaita Sans", sans-serif;
        font-size: 13px;
      }

      .control-center,
      .notification {
        background: alpha(${rosePineDawn.surface}, 0.94);
        border: 1px solid ${rosePineDawn.overlay};
        border-radius: 8px;
        color: ${rosePineDawn.text};
      }

      .notification-content {
        padding: 12px;
      }
    '';
  };
}
