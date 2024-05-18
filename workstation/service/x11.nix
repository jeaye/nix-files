{ config, pkgs, ... }:

{
  services.xserver =
  {
    enable = true;
    autorun = true;
    layout = "us";
    #tty = 2;

    windowManager =
    {
      i3 =
      {
        enable = true;
        extraPackages = with pkgs; [ dmenu polybar i3lock hsetroot xautolock xorg.xwininfo ];
      };
    };
    desktopManager =
    {
      xterm.enable = false;
    };
    displayManager =
    {
      startx.enable = true;
    };
  };

  nixpkgs.overlays = [
    (final: prev: {
      polybar = prev.polybar.override
      {
        pulseSupport = true;
        i3Support = true;
      };
    })
  ];

  fonts =
  {
    fontconfig =
    {
      enable = true;
      allowBitmaps = true;
      useEmbeddedBitmaps = true;
    };
    fontDir.enable = true;
    enableGhostscriptFonts = true;
    packages = with pkgs;
    [
      google-fonts
      fira-code
      noto-fonts
      noto-fonts-emoji
      # Some international fonts.
      unifont
      # Icons.
      nerdfonts
      font-awesome
      material-icons
      material-design-icons
      material-symbols
      siji
    ];
  };

  services.redshift =
  {
    enable = true;
    temperature.day = 5000;
    temperature.night = 4500;
  };
  location.latitude = 37.5778696;
  location.longitude = -122.34809;

  # i3 docs say this is required for i3blocks.
  environment.pathsToLink = [ "/libexec" ];

  environment.sessionVariables =
  {
    # Allow GTK 2.0/3.0 themes to be found.
    GTK_DATA_PREFIX = "/run/current-system/sw";
    # Allow KDE apps to work better in i3.
    DESKTOP_SESSION = "kde";
  };

  # Enable OpenGL
  hardware.opengl =
  {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
  };

  # Load nvidia driver for Xorg and Wayland
  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.nvidia =
  {
    # Modesetting is required.
    modesetting.enable = true;

    # Nvidia power management. Experimental, and can cause sleep/suspend to fail.
    powerManagement.enable = false;
    # Fine-grained power management. Turns off GPU when not in use.
    # Experimental and only works on modern Nvidia GPUs (Turing or newer).
    powerManagement.finegrained = false;

    # Use the NVidia open source kernel module (not to be confused with the
    # independent third-party "nouveau" open source driver).
    # Support is limited to the Turing and later architectures. Full list of
    # supported GPUs is at:
    # https://github.com/NVIDIA/open-gpu-kernel-modules#compatible-gpus
    # Only available from driver 515.43.04+
    # Currently alpha-quality/buggy, so false is currently the recommended setting.
    open = false;

    # Enable the Nvidia settings menu,
	  # accessible via `nvidia-settings`.
    nvidiaSettings = true;

    # Optionally, you may need to select the appropriate driver version for your specific GPU.
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };
}
