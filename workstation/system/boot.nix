{ config, pkgs, ... }:

{
  boot =
  {
    loader.grub.device = "/dev/sda";
    tmpOnTmpfs = false; # Done manually below.
  };

  systemd.mounts =
  [
    { # Put /tmp on a protected tmpfs
      description = "Temporary Directory (/tmp)";
      what = "tmpfs";
      where = "/tmp";
      documentation =
      [
        "man:hier(7)"
        "https://www.freedesktop.org/wiki/Software/systemd/APIFileSystems"
      ];
      before = ["local-fs.target" "umount.target"];
      after = ["swap.target"];
      conflicts = ["umount.target"];
      options = "rw,nosuid,nodev,noexec";
      type = "tmpfs";

      unitConfig =
      {
        ConditionPathIsSymbolicLink = "!/tmp";
        DefaultDependencies = "no";
      };
    }
  ];

  services.nixosManual.ttyNumber = 6;
}
