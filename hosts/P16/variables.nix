{
  # Git Configuration ( For Pulling Software Repos )
  gitUsername = "voiceless-zell";
  gitEmail = "peter.bouchard2893@proton.me";

  # Hyprland Settings
  extraMonitorSettings = "
    monitor = eDP-1,2560x1600,0x0,1
    monitor = DP-4,1920x1080,-1080x0,1,transform,3
    monitor = HDMI-A-1,1920x1080,-3000x0,1
    monitor = DP-3,1920x1080,-4920x0,1
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
