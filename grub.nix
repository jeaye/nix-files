{ config, pkgs, ... }:

{
  boot.kernelPackages = pkgs.linuxPackages_4_2;

  boot.loader.grub = {
    enable = true;
    version = 2;
    device = "/dev/sda";
    extraEntries = ''
    menuentry 'Slackware-14.1 4.0.1' {
      insmod gzio
      insmod part_msdos
      insmod ext2
      set root='hd1,msdos1'
      search --no-floppy --fs-uuid --set=root aaafb37e-d2f3-4983-b1ca-fb98079cb45f
      echo	'Loading Linux 4.0.1...'
      linux	/boot/vmlinuz root=/dev/sdb1 ro
      echo	'Loading initial ramdisk ...'
      initrd	/boot/initrd.gz
    }
    '';
  };
}
