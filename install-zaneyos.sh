#!/usr/bin/env bash

if [ -n "$(grep -i nixos < /etc/os-release)" ]; then
  echo "Verified this is NixOS."
  echo "-----"
else
  echo "This is not NixOS or the distribution information is not available."
  exit
fi

if command -v git &> /dev/null; then
  echo "Git is installed, continuing with installation."
  echo "-----"
else
  echo "Git is not installed. Please install Git and try again."
  echo "Example: nix-shell -p git"
  exit
fi

echo "Default options are in brackets []"
echo "Just press enter to select the default"
sleep 2

echo "-----"

echo "Ensure In Home Directory"
cd || exit

echo "-----"

read -rp "Enter Your New Hostname: [ default ] " hostName
if [ -z "$hostName" ]; then
  hostName="default"
fi

echo "-----"

read -rp "Enter Your Hardware Profile (GPU)
Options:
[ amd ]
nvidia
nvidia-laptop
intel
vm
Please type out your choice: " profile
if [ -z "$profile" ]; then
  profile="amd"
fi

echo "-----"

backupname=$(date "+%Y-%m-%d-%H-%M-%S")
if [ -d "zaney-zellos" ]; then
  echo "Zaney-zellos exists, backing up to .config/zaney-zellos-backups folder."
  if [ -d ".config/zaney-zellos-backups" ]; then
    echo "Moving current version of ZaneyOS to backups folder."
    mv "$HOME"/zaney-zellos .config/zaney-zellos-backups/"$backupname"
    sleep 1
  else
    echo "Creating the backups folder & moving Zaney-zellos to it."
    mkdir -p .config/zaney-zellos-backups
    mv "$HOME"/zaney-zellos .config/zaney-zellos-backups/"$backupname"
    sleep 1
  fi
else
  echo "Thank you for choosing Zaney-zellos."
  echo "I hope you find your time here enjoyable!"
fi

echo "-----"

echo "Cloning & Entering Zaney-zellos Repository"
git clone https://github.com/voiceless-zell/zaney-zellos.git
cd zaney-zellos || exit

set_nix_attr() {
  local file="$1"
  local attr="$2"
  local value="$3"

  if grep -qE "^[[:space:]]*${attr}[[:space:]]*=" "$file"; then
    sed -i "s|^[[:space:]]*${attr}[[:space:]]*=.*|  ${attr} = \"${value}\";|" "$file"
  else
    sed -i "1a\\  ${attr} = \"${value}\";\n" "$file"
  fi
}

if [ -d "hosts/$hostName" ]; then
  echo "Existing host '$hostName' found. Preserving host-specific files and refreshing hardware.nix only."
  reuse_existing_host="yes"
else
  echo "Creating new host from hosts/default template."
  mkdir -p "hosts/$hostName"
  cp hosts/default/*.nix "hosts/$hostName"
  reuse_existing_host="no"
fi

installusername=$(echo "$USER")
git config --global user.name "$installusername"
git config --global user.email "$installusername@gmail.com"
git add .
git config --global --unset-all user.name
git config --global --unset-all user.email
set_nix_attr "./hosts/$hostName/variables.nix" "profile" "$profile"

if [ "$reuse_existing_host" = "no" ]; then
  read -rp "Enter your keyboard layout: [ us ] " keyboardLayout
  if [ -z "$keyboardLayout" ]; then
    keyboardLayout="us"
  fi

  set_nix_attr "./hosts/$hostName/variables.nix" "keyboardLayout" "$keyboardLayout"

  echo "-----"

  read -rp "Enter your console keymap: [ us ] " consoleKeyMap
  if [ -z "$consoleKeyMap" ]; then
    consoleKeyMap="us"
  fi

  set_nix_attr "./hosts/$hostName/variables.nix" "consoleKeyMap" "$consoleKeyMap"
else
  echo "Keeping existing keyboard and console settings from ./hosts/$hostName/variables.nix"
fi

echo "-----"

sed -i "/^\s*username[[:space:]]*=[[:space:]]*\"/s/\"\(.*\)\"/\"$installusername\"/" ./flake.nix

echo "-----"

echo "Generating The Hardware Configuration"
sudo nixos-generate-config --show-hardware-config > ./hosts/$hostName/hardware.nix

echo "-----"

echo "Setting Required Nix Settings Then Going To Install"
NIX_CONFIG="experimental-features = nix-command flakes"

echo "-----"

sudo nixos-rebuild switch --flake ~/zaney-zellos/#${hostName}
