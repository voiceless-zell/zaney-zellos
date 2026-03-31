<div align="center">

    # My twist on zaneyos

        This is a fork from zaneyOS here: https://gitlab.com/Zaney/zaneyos

    ## The Below documentation, only has slight modifications, from the original. I have updated the script to install the config from this repository.

    ### TODO

    - [ ] Add WSL config (no gui)
    - [ ] add server config (limited software/ no GUI)
    - [ ] add more fine grained notes
    - [ ] declare Kali linux VM
    - [ ] reconfig script to add additional unique hostname variable, for ease of use in multi host Configs
    - [ ] reconfig script too add additioal unique username variables, for ease of use in multi user Configs


    #### Changes as of 3-5-2025
        - added shell alias of fl "cd ~/zaney-zellos/ && v" ( quick access to edit config)
        - Multiple personel hosts added

## ZaneyOS 🟰 Best ❄️ NixOS Configs

ZaneyOS is a simple way of reproducing my configuration on any NixOS system.
This includes the wallpaper, scripts, applications, config files, and more.

<img align="center" width="80%" src="https://gitlab.com/Zaney/zaneyos/-/raw/main/demo.png" />

**Inspiration for the Waybar config
[here](https://github.com/justinlime/dotfiles).**

</div>

> **This project has a [Wiki](https://zaney.org/wiki/zaneyos-2.3/). Find out how
> to use ZaneyOS here!** **I have put a lot of effort into the
> [documentation](https://zaney.org/wiki/zaneyos-2.3/) so it should be accurate.
> However, please if you notice that something is wrong with it create an issue
> or reach out to me on Discord.**

#### 🍖 Requirements

- You must be running on NixOS.
- The zaneyos folder (this repo) is expected to be in your home directory.
- Must have installed using GPT & UEFI. Systemd-boot is what is supported, for
  GRUB you will have to brave the internet for a how-to. ☺️
- Manually editing your host specific files. The host is the specific computer
  your installing on.

#### 🎹 Pipewire & Notification Menu Controls

- We are using the latest and greatest audio solution for Linux. Not to mention
  you will have media and volume controls in the notification center available
  in the top bar.

#### 🏇 Optimized Workflow & Simple Yet Elegant Neovim

- Using Hyprland for increased elegance, functionality, and effeciency.
- No massive Neovim project here. This is my simple, easy to understand, yet
  incredible Neovim setup.

#### 🖥️ Multi Host & User Configuration

- You can define separate settings for different host machines and users.
- Easily specify extra packages for your users in the modules/core/user.nix
  file.
- Easy to understand file structure and simple, but encompassing,
  configuratiion.

#### 👼 An Incredible Community Focused On Support

- The entire idea of ZaneyOS is to make NixOS an approachable space that is
  actually a great community that you want to be in.
- Many people who are patient and happy to spend their free time helping you are
  running ZaneyOS. Feel free to reach out on the Discord for any help with
  anything.

<div align="center">

Please do yourself a favor and
[read the wiki](https://zaney.org/wiki/zaneyos-2.3/).

</div>

#### 📦 How To Install Packages?

- You can search the [Nix Packages](https://search.nixos.org/packages?) &
  [Options](https://search.nixos.org/options?) pages for what a package may be
  named or if it has options available that take care of configuration hurdles
  you may face.
- To add a package there are the sections for it in `modules/core/packages.nix`
  and `modules/core/user.nix`. One is for programs available system wide and the
  other for your users environment only.

#### 🙋 Having Issues / Questions?

- Please feel free to raise an issue on the repo, please label a feature request
  with the title beginning with [feature request], thank you!
- Contact me on [Discord](https://discord.gg/2cRdBs8) as well, for a potentially
  faster response.

### ⬇️ Install

#### 📜 Script:

This is the easiest and recommended way of starting out. The script is not meant
to allow you to change every option that you can in the flake or help you
install extra packages. It is simply here so you can get my configuration
installed with as little chances of breakages and then fiddle to your hearts
content!

Simply copy this and run it:

```
nix-shell -p git curl
```

Then:

```
sh <(curl -L https://raw.githubusercontent.com/voiceless-zell/zaney-zellos/refs/heads/master/install-zaneyos.sh)
```

#### 🦽 Manual:

Run this command to ensure Git & Vim are installed:

```
nix-shell -p git vim
```

Clone this repo & enter it:

```
git clone https://github.com/voiceless-zell/zaney-zellos.git
cd zaney-zellos
```

- _You should stay in this folder for the rest of the install_

Create the host folder for your machine(s)

```
cp -r hosts/default hosts/<your-desired-hostname>
```

**🪧🪧🪧 Edit `hosts/<your-desired-hostname>/variables.nix` 🪧🪧🪧**

Each host now declares its own hardware profile inside `hosts/<your-desired-hostname>/variables.nix`:

```nix
profile = "intel";
```

Valid profiles are:

- amd
- nvidia
- nvidia-laptop
- intel
- vm

Generate or refresh your `hardware.nix` like so:

```
sudo nixos-generate-config --show-hardware-config > hosts/<your-desired-hostname>/hardware.nix
```

Then build by **host name**, not profile:

```
NIX_CONFIG="experimental-features = nix-command flakes" \
sudo nixos-rebuild switch --flake .#<your-desired-hostname>
```

#### 🔁 Rebuild from an existing local checkout

If the repo is already on the machine, you do **not** need to clone it again.

Example for `P16`:

```
cd ~/zaney-zellos
sudo nixos-generate-config --show-hardware-config > hosts/P16/hardware.nix
NIX_CONFIG="experimental-features = nix-command flakes" \
sudo nixos-rebuild switch --flake .#P16
```

The install script keeps overwriting `hosts/<host>/hardware.nix` for the selected host, so hardware data stays host-specific.

Now when you want to rebuild the configuration you have access to an alias `fr`
that rebuilds the current host's flake.

Hope you enjoy!
