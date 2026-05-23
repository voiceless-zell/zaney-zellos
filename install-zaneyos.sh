#!/usr/bin/env bash
set -euo pipefail

REPO_URL="https://github.com/voiceless-zell/zaney-zellos.git"
REPO_NAME="zaney-zellos"
DEFAULT_USERNAME="zell"
DEFAULT_HOST="default"
DEFAULT_PROFILE="amd"

require_nixos() {
  if [ ! -r /etc/os-release ] || ! grep -qi '^ID=.*nixos\|^ID_LIKE=.*nixos' /etc/os-release; then
    echo "This installer must be run from NixOS or a NixOS live ISO."
    exit 1
  fi
  echo "Verified NixOS environment."
}

require_command() {
  local command_name="$1"
  local package_hint="$2"

  if ! command -v "$command_name" >/dev/null 2>&1; then
    echo "Missing required command: $command_name"
    echo "Run this first: nix-shell -p $package_hint"
    exit 1
  fi
}

run_root() {
  if [ "${EUID:-$(id -u)}" -eq 0 ]; then
    "$@"
  else
    sudo "$@"
  fi
}

prompt_default() {
  local prompt="$1"
  local default_value="$2"
  local answer=""

  read -r -p "$prompt [ $default_value ] " answer
  if [ -z "$answer" ]; then
    printf '%s\n' "$default_value"
  else
    printf '%s\n' "$answer"
  fi
}

valid_profile() {
  case "$1" in
    amd|asus-g14|intel|nvidia|nvidia-laptop|vm) return 0 ;;
    *) return 1 ;;
  esac
}

set_nix_attr() {
  local file="$1"
  local attr="$2"
  local value="$3"
  local escaped_value

  escaped_value=$(printf '%s' "$value" | sed 's/[\\&|]/\\&/g')

  if grep -qE "^[[:space:]]*${attr}[[:space:]]*=" "$file"; then
    sed -i "s|^[[:space:]]*${attr}[[:space:]]*=.*|  ${attr} = \"${escaped_value}\";|" "$file"
  else
    sed -i "1a\\  ${attr} = \"${escaped_value}\";\n" "$file"
  fi
}

replace_flake_username() {
  local username="$1"
  local escaped_username

  escaped_username=$(printf '%s' "$username" | sed 's/[\\&/]/\\&/g')
  sed -i "s/^\([[:space:]]*username[[:space:]]*=[[:space:]]*\)\".*\";/\1\"${escaped_username}\";/" ./flake.nix
}

detect_mode() {
  if mountpoint -q /mnt; then
    printf '%s\n' "install"
  else
    printf '%s\n' "switch"
  fi
}

prepare_repo() {
  local mode="$1"
  local repo_dir
  local backup_name

  if [ "$mode" = "install" ]; then
    repo_dir=$(mktemp -d /tmp/zaney-zellos-install.XXXXXX)
    git clone "$REPO_URL" "$repo_dir" >&2
    printf '%s\n' "$repo_dir"
    return 0
  fi

  cd "$HOME"
  backup_name=$(date "+%Y-%m-%d-%H-%M-%S")

  if [ -d "$REPO_NAME" ]; then
    echo "Existing $REPO_NAME checkout found; moving it to ~/.config/zaney-zellos-backups/$backup_name" >&2
    mkdir -p "$HOME/.config/zaney-zellos-backups"
    mv "$HOME/$REPO_NAME" "$HOME/.config/zaney-zellos-backups/$backup_name"
  fi

  git clone "$REPO_URL" "$HOME/$REPO_NAME" >&2
  printf '%s\n' "$HOME/$REPO_NAME"
}

create_or_refresh_host() {
  local host_name="$1"
  local profile="$2"
  local reuse_existing_host="no"

  if [ -d "hosts/$host_name" ]; then
    echo "Existing host '$host_name' found. Preserving host-specific files and refreshing hardware.nix only."
    reuse_existing_host="yes"
  else
    echo "Creating new host '$host_name' from hosts/default template."
    mkdir -p "hosts/$host_name"
    cp hosts/default/*.nix "hosts/$host_name"
  fi

  set_nix_attr "./hosts/$host_name/variables.nix" "profile" "$profile"

  if [ "$reuse_existing_host" = "no" ]; then
    local keyboard_layout
    local console_keymap

    keyboard_layout=$(prompt_default "Enter your keyboard layout:" "us")
    set_nix_attr "./hosts/$host_name/variables.nix" "keyboardLayout" "$keyboard_layout"

    console_keymap=$(prompt_default "Enter your console keymap:" "us")
    set_nix_attr "./hosts/$host_name/variables.nix" "consoleKeyMap" "$console_keymap"
  else
    echo "Keeping existing keyboard and console settings from ./hosts/$host_name/variables.nix"
  fi
}

generate_hardware_config() {
  local mode="$1"
  local host_name="$2"

  echo "Generating hardware configuration for host '$host_name'."
  if [ "$mode" = "install" ]; then
    run_root nixos-generate-config --root /mnt --show-hardware-config > "./hosts/$host_name/hardware.nix"
  else
    run_root nixos-generate-config --show-hardware-config > "./hosts/$host_name/hardware.nix"
  fi
}

install_or_switch() {
  local mode="$1"
  local host_name="$2"
  local repo_dir="$3"

  export NIX_CONFIG="experimental-features = nix-command flakes"
  git add -A

  if [ "$mode" = "install" ]; then
    if ! mountpoint -q /mnt; then
      echo "Install mode requires your target root filesystem mounted at /mnt."
      echo "Partition, format, and mount your target disk first; this script will not do that dangerous bit for you."
      exit 1
    fi

    echo "Installing NixOS to /mnt with flake .#$host_name"
    run_root nixos-install --flake "$repo_dir#$host_name"
    return 0
  fi

  echo "Switching this running NixOS system to flake .#$host_name"
  run_root nixos-rebuild switch --flake "$repo_dir#$host_name"
}

main() {
  require_nixos
  require_command git git
  require_command nixos-generate-config nixos-install-tools

  echo "Default options are in brackets []. Press Enter to accept the default."
  echo "-----"

  local detected_mode
  local mode
  local install_username
  local host_name
  local profile
  local repo_dir

  detected_mode=$(detect_mode)
  mode=$(prompt_default "Install mode: install to /mnt from live ISO, or switch current system?" "$detected_mode")
  case "$mode" in
    install|switch) ;;
    *)
      echo "Invalid mode '$mode'. Use 'install' or 'switch'."
      exit 1
      ;;
  esac

  if [ "$mode" = "install" ] && ! mountpoint -q /mnt; then
    echo "Live ISO install mode selected, but /mnt is not mounted."
    echo "Mount your target NixOS root filesystem at /mnt first. Example: mount /dev/<root-partition> /mnt"
    exit 1
  fi

  if [ "$mode" = "install" ]; then
    require_command nixos-install nixos-install-tools
  else
    require_command nixos-rebuild nixos-rebuild
  fi

  install_username=$(prompt_default "Enter the NixOS username to create/use:" "$DEFAULT_USERNAME")
  host_name=$(prompt_default "Enter your hostname:" "$DEFAULT_HOST")

  echo "Available hardware profiles: amd, asus-g14, intel, nvidia, nvidia-laptop, vm"
  profile=$(prompt_default "Enter your hardware profile:" "$DEFAULT_PROFILE")
  if ! valid_profile "$profile"; then
    echo "Invalid profile '$profile'."
    exit 1
  fi

  echo "-----"
  repo_dir=$(prepare_repo "$mode")
  cd "$repo_dir"

  create_or_refresh_host "$host_name" "$profile"
  replace_flake_username "$install_username"
  generate_hardware_config "$mode" "$host_name"
  install_or_switch "$mode" "$host_name" "$repo_dir"

  echo "-----"
  echo "Done. Repository used: $repo_dir"
  if [ "$mode" = "install" ]; then
    echo "After reboot, clone or copy this repo into /home/$install_username/$REPO_NAME before future rebuilds."
  fi
}

main "$@"
