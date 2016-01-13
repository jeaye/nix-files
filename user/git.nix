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
    ];
  };

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
        chown -R git:users /etc/user/git
      '';
    };
  };
}
