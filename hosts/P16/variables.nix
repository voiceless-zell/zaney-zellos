{
  profile = "nvidia-laptop";

  # Git Configuration ( For Pulling Software Repos )
  gitUsername = "voiceless-zell";
  gitEmail = "peter.bouchard2893@proton.me";

  # Hyprland Settings
  extraMonitorSettings = "
    monitor = DP-3,1920x1080@60,0x0,1
    monitor = HDMI-A-1,1920x1080@60,1920x0,1
    monitor = DP-2,1920x1080@60,3840x0,1,transform,3
    monitor = eDP-1,2560x1600@165.02,5760x0,1
    ";

  # Waybar Settings
  clock24h = false;

  # Program Options
  browser = "brave"; # Set Default Browser (google-chrome-stable for google-chrome)
  terminal = "ghostty"; # Set Default System Terminal
  keyboardLayout = "us";
  consoleKeyMap = "us";

  # For Nvidia Prime support
  intelID = "PCI:1:0:0";
  nvidiaID = "PCI:0:2:0";
}
