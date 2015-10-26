{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

  # Use the GRUB 2 boot loader.
  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  boot.loader.grub.device = "/dev/sda";
  boot.loader.grub.extraEntries = ''
    menuentry 'Slackware-14.1 4.0.1' {
	insmod gzio
	insmod part_msdos
	insmod ext2
	set root='hd1,msdos1'
	if [ x = xy ]; then
	  search --no-floppy --fs-uuid --set=root --hint-bios=hd1,msdos1 --hint-efi=hd1,msdos1 --hint-baremetal=ahci1,msdos1  aaafb37e-d2f3-4983-b1ca-fb98079cb45f
	else
	  search --no-floppy --fs-uuid --set=root aaafb37e-d2f3-4983-b1ca-fb98079cb45f
	fi
	echo	'Loading Linux 4.0.1...'
	linux	/boot/vmlinuz root=/dev/sdb1 ro  
	echo	'Loading initial ramdisk ...'
	initrd	/boot/initrd.gz
    }
  '';

  networking.hostName = "nixos";
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  i18n = {
    consoleFont = "Lat2-Terminus16";
    consoleKeyMap = "us";
    defaultLocale = "en_US.UTF-8";
  };

  time.timeZone = "Singapore/Singapore";

  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = with pkgs; [
    wget
    vim
    tmux
    git
    firefox
    elinks
  ];

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Enable the X11 windowing system.
  services.xserver.enable = true;
  services.xserver.layout = "us";
  services.xserver.synaptics.enable = true;
  services.xserver.synaptics.twoFingerScroll = true;
  services.xserver.windowManager.i3.enable = true;
  services.xserver.windowManager.default = "i3";

  # Nvidia
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.opengl.driSupport32Bit = true;

  users.extraUsers.jeaye = {
    isNormalUser = true;
    home = "/home/jeaye";
    extraGroups = [ "wheel" "networkmanager" ];
    uid = 1000;
  };

  system.stateVersion = "15.09";
}
