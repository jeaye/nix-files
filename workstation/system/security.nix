{ config, pkgs, ... }:

{
  security.lockKernelModules = false;

  systemd.mounts =
  [
    { # Put /tmp on a protected tmpfs. This sucks up more RAM though.
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
      options = "rw,nosuid,nodev";
      type = "tmpfs";

      unitConfig =
      {
        ConditionPathIsSymbolicLink = "!/tmp";
        DefaultDependencies = "no";
      };
    }
  ];
}
