{ ... }:

{
  xdg = {
    userDirs = {
      enable = true;
      createDirectories = true;
      setSessionVariables = true;
    };

    mimeApps = {
      enable = true;
      defaultApplications = {
        "audio/aac" = [ "vlc.desktop" ];
        "audio/flac" = [ "vlc.desktop" ];
        "audio/mpeg" = [ "vlc.desktop" ];
        "audio/mp4" = [ "vlc.desktop" ];
        "audio/ogg" = [ "vlc.desktop" ];
        "audio/wav" = [ "vlc.desktop" ];
        "audio/webm" = [ "vlc.desktop" ];
        "video/3gpp" = [ "vlc.desktop" ];
        "video/mp2t" = [ "vlc.desktop" ];
        "video/mp4" = [ "vlc.desktop" ];
        "video/mpeg" = [ "vlc.desktop" ];
        "video/ogg" = [ "vlc.desktop" ];
        "video/quicktime" = [ "vlc.desktop" ];
        "video/webm" = [ "vlc.desktop" ];
        "video/x-matroska" = [ "vlc.desktop" ];
        "video/x-msvideo" = [ "vlc.desktop" ];
        "x-content/video-dvd" = [ "vlc.desktop" ];
        "x-content/video-vcd" = [ "vlc.desktop" ];
        "x-content/video-svcd" = [ "vlc.desktop" ];
      };
    };
  };
}
