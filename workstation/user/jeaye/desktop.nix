{ config, pkgs, expr, buildVM, ... }:

let
  iconTheme = pkgs.breeze-icons.out;
  themeEnv =
  ''
    # GTK3: add /etc/xdg/gtk-3.0 to search path for settings.ini
    # We use /etc/xdg/gtk-3.0/settings.ini to set the icon and theme name for GTK 3
    export XDG_CONFIG_DIRS="/etc/xdg:$XDG_CONFIG_DIRS"

    # GTK2 theme + icon theme
    export GTK2_RC_FILES=${pkgs.writeText "iconrc" ''gtk-icon-theme-name="breeze"''}:${pkgs.breeze-gtk}/share/themes/Breeze/gtk-2.0/gtkrc:$GTK2_RC_FILES

    # SVG loader for pixbuf (needed for GTK svg icon themes)
    export GDK_PIXBUF_MODULE_FILE=$(echo ${pkgs.librsvg.out}/lib/gdk-pixbuf-2.0/*/loaders.cache)

    # QT5: convince it to use our preferred style
    export QT_STYLE_OVERRIDE=kvantum
  '';
in
{

  environment.extraInit =
  ''
    ${themeEnv}

    # These are the defaults, but some applications are buggy so we set them
    # here anyway.
    export XDG_CONFIG_HOME=$HOME/.config
    export XDG_DATA_HOME=$HOME/.local/share
    export XDG_CACHE_HOME=$HOME/.cache
  '';

  # QT4/5 global theme
  environment.etc."xdg/Trolltech.conf" =
  {
    text =
    ''
      [Qt]
      style=Breeze
    '';
    mode = "444";
  };

  # GTK3 global theme (widget and icon theme)
  environment.etc."xdg/gtk-3.0/settings.ini" =
  {
    text =
    ''
      [Settings]
      gtk-icon-theme-name=breeze
      gtk-theme-name=Breeze-gtk
    '';
    mode = "444";
  };

  users.users.jeaye =
  {
    packages = with pkgs;
    [
      redshift
      imagemagick
      flameshot
      xfce.thunar
      # Needed for thumbnails in pcmanfm
      xfce.tumbler
      # Allows pcmanfm to recognize different file types
      shared-mime-info

      # Qt theme
      breeze-qt5
      breeze-gtk

      # Icons (Main)
      iconTheme

      # Icons (Fallback)
      gnome.adwaita-icon-theme

      # Qt Style tooling
      libsForQt5.qtstyleplugin-kvantum
      libsForQt5.qt5ct
      themechanger
    ];
  };

  nixpkgs.config.qt5 =
  {
    enable = true;
    platformTheme = "qt5ct";
  };
  environment.variables.QT_QPA_PLATFORMTHEME = "qt5ct";

  # Make applications find files in <prefix>/share
  environment.pathsToLink = [ "/share" ];
}
