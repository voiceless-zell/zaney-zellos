{pkgs}:
pkgs.writeShellScriptBin "fix-monitors" ''
  set -eu

  notify() {
    if command -v notify-send >/dev/null 2>&1; then
      notify-send "Monitor Recovery" "$1"
    fi
  }

  hypr() {
    ${pkgs.hyprland}/bin/hyprctl keyword monitor "$1" || true
  }

  notify "Reapplying dock monitor layout..."

  hypr "HDMI-A-1,1920x1080@60,-3000x0,1"
  sleep 1

  hypr "DP-4,disable"
  sleep 2
  hypr "DP-4,1920x1080@60,-1080x0,1,transform,3"
  sleep 3

  notify "Giving DP-3 extra persuasion..."
  hypr "DP-3,disable"
  sleep 3
  hypr "DP-3,1920x1080@60,-4920x0,1"
  sleep 4
  hypr "DP-3,disable"
  sleep 2
  hypr "DP-3,1920x1080@60,-4920x0,1"
  sleep 5

  notify "Monitor recovery pass complete."
''
