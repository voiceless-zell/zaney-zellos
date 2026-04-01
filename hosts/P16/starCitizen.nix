{
  # Cachix setup
  nix.settings = {
    substituters = ["https://nix-citizen.cachix.org"];
    trusted-public-keys = ["nix-citizen.cachix.org-1:lPMkWc2X8XD4/7YPEEwXKKBg+SVbYTVrAaLA2wQTKCo="];
  };

  programs.rsi-launcher = {
    enable = true;
    preCommands = ''
      export DXVK_HUD=compiler
      export MANGO_HUD=1
    '';
  };
}
