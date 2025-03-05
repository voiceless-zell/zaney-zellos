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

backupname=$(date "+%Y-%m-%d-%H-%M-%S")
if [ -d "zaney-zellos" ]; then
  echo "Zaney-zellos exists, backing up to .config/zaney-zellos-backups folder."
  mkdir -p .config/zaney-zellos-backups
  mv "$HOME"/zaney-zellos .config/zaney-zellos-backups/"$backupname"
  sleep 1
else
  echo "Thank you for choosing Zaney-zellos."
  echo "I hope you find your time here enjoyable!"
fi

echo "-----"

echo "Cloning & Entering Zaney-zellos Repository"
git clone https://github.com/voiceless-zell/zaney-zellos.git
cd zaney-zellos || exit
mkdir -p hosts/"$hostName"
cp hosts/default/*.nix hosts/"$hostName"
installusername=$(echo $USER)
git config --global user.name "$installusername"
git config --global user.email "$installusername@gmail.com"
git add .
git config --global --unset-all user.name
git config --global --unset-all user.email

# Modify flake.nix to append the new hostname instead of replacing it
if ! grep -q "host = \"$hostName\"" flake.nix; then
  sed -i "/^\s*host[[:space:]]*=/a \    \"$hostName\"" flake.nix
fi

echo "-----"

echo "Generating The Hardware Configuration"
sudo nixos-generate-config --show-hardware-config > ./hosts/$hostName/hardware.nix

echo "-----"

echo "Setting Required Nix Settings Then Going To Install"
NIX_CONFIG="experimental-features = nix-command flakes"

echo "-----"

sudo nixos-rebuild switch --flake ~/zaney-zellos/#$hostName
`
