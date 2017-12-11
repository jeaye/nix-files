{ config, pkgs, ... }:

{
  boot.kernel.sysctl =
  {
    # Prevent unprivileged users from reading dmesg.
    "kernel.dmesg_restrict" = 1;
  };

  # Prevent users from read the process info of other users.
  # TODO: Allow a group id to bypass this
  security.hideProcessInformation = true;
}
