{ config, pkgs, ... }:

{
  users.users.git =
  {
    isNormalUser = true;
    home = "/etc/user/git";
    createHome = true;

    openssh.authorizedKeys.keys =
    [
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDZ3FLbdsKAdYsYf/kc62WhZr9DbGMqqB9zKQbtRCsm0PS2Ihkl1niQwX7iSESk3oDfnosU+CA5MM+ZHFovo3urHQ75KpXU+tFBgujfLb3W5Es4aW4tQVqkf5BgUg2Og1b8sxZD3YTHJUoSj7tTwnh1HUcnAzC5q/gcKd+o8tqWaK7FxmdVeX83PVSoNUIFDSykEex4hT/Y+WNc9HAC6Vwv3ciYdsjn6hPWc+fStFnWqlhE+rZqsaUB3+07DFlverwGeD/W4Ad1MOs2lF+CbqZXdFhSYb/rJK/AEllSXIKfr+Vn8LI3o0rlHrIe8LwxDl7LaTgPBllVDZSoAPxzRpHN jeaye@darkstar"
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDPgOBuCLoXIRi4ha+qD8DuMKbDEjEwQazxWfbojvJIIP6tzMaftYSswrdZRnl7pEYQqm3yQ1e5R6G7DL1/B+wg+PYW9yglgesyLGa2NFrmfjuM98AU4dsyi0tqrqc/G5SMT1T3nwQmqc8TvVVfemVPORryCwzDrMrWRcdjVMqfkKMMIOhOzYQWZqIWNqwQTVgjDpjI2vWeQZLr6z5y/4B53CqwhAq3vOo5NRa4/Py/kQxtJBA/wZ4F2X/60qB0Xah5+BeXl9vz2rMzezf8s0GALioYfUZIE4ScXTnJF7lNh5BmyhffOV3ocqTkafJJI6SEgiqf1a1lif/NoSXaVIN7 jeaye@max"
    ];
  };
  users.groups.git = {};

  # Ensure some directories exist
  environment.etc."user/git/dotfiles/.manage-directory".text = "";

  # XXX: Manually bring in dotfiles repo
  system.activationScripts =
  {
    git-home =
    {
      deps = [];
      text =
      ''
        PATH=${pkgs.git}/bin:$PATH
        PATH=${pkgs.gnused}/bin:$PATH

        if [ ! -d /etc/user/dotfiles ];
        then
          git clone --recursive /etc/user/git/dotfiles /etc/user/dotfiles
        fi
        chgrp -R git /etc/user/dotfiles
        chmod -R g+w /etc/user/dotfiles
      '';
    };
  };
}
