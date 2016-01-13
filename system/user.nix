{ config, pkgs, ... }:

{
  security.sudo =
  {
    enable = false;
    wheelNeedsPassword = true;
  };

  security.pam.loginLimits =
  [
    { domain = "*"; item = "nproc"; type = "soft"; value = "256"; }
    { domain = "*"; item = "nproc"; type = "hard"; value = "256"; }
    { domain = "*"; item = "maxlogins"; type = "hard"; value = "3"; }
    { domain = "*"; item = "nofile"; type = "hard"; value = "512"; }
  ];

  users.users.jeaye =
  {
    isNormalUser = true;
    home = "/etc/user/jeaye";
    extraGroups = [ "wheel" ];
  };

  users.users.fu-er =
  {
    isNormalUser = true;
    home = "/etc/user/fu-er";
  };

  system.activationScripts =
  {
    homes =
    {
      deps = [];
      text = (builtins.foldl'
      (us: u:
      ''
        ${us}
        ln -sf /etc/user/dotfiles/bashrc /etc/user/${u.name}/.bashrc;
        chown -R ${u.name}:users /etc/user/${u.name};
      '')
      ""
      (builtins.filter (u: u.isNormalUser)
             (map (key: builtins.getAttr key config.users.users)
                  (builtins.attrNames config.users.users))));
    };
  };

  # Allow useradd/groupadd imperatively
  users.mutableUsers = true;
}
