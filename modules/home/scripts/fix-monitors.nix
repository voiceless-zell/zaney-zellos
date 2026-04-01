{pkgs}:
pkgs.writeShellScriptBin "fix-monitors" ''
  set -eu

  notify() {
    if command -v notify-send >/dev/null 2>&1; then
      notify-send "Monitor Recovery" "$1"
    fi
  }

  notify "Reapplying dock monitor layout..."

  ${pkgs.hyprland}/bin/hyprctl keyword monitor "HDMI-A-1,1920x1080@60,-3000x0,1" || true
  sleep 1

  ${pkgs.hyprland}/bin/hyprctl keyword monitor "DP-4,disable" || true
  sleep 2
  ${pkgs.hyprland}/bin/hyprctl keyword monitor "DP-4,1920x1080@60,-1080x0,1,transform,3" || true
  sleep 2

  ${pkgs.hyprland}/bin/hyprctl keyword monitor "DP-3,disable" || true
  sleep 2
  ${pkgs.hyprland}/bin/hyprctl keyword monitor "DP-3,1920x1080@60,-4920x0,1" || true
  sleep 2

  notify "Monitor recovery pass complete."
''
