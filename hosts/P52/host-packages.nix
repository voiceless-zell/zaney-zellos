{pkgs, ...}: {
  environment = {
    systemPackages = with pkgs; [
      audacity
      discord
      nodejs
      obs-studio
    ];
    pathsToLink = ["/share/zsh"];
  };
}
