{ lib, ... }:

{
  qt = {
    enable = true;
    style.name = "adwaita-dark";
    platformTheme.name = lib.mkForce "gtk3";
  };
}
