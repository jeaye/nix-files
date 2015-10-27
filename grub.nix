{ config, pkgs, ... }:

{
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
}
