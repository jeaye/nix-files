{ config, pkgs, lib, ... }:

{
  environment.systemPackages = with pkgs;
  [
    slrn
  ];

  environment.etc."user/usenet/slrnrc".text =
    lib.readFile ./data/slrnrc;

  users.users.usenet =
  {
    isNormalUser = true;
    home = "/home/usenet";
    createHome = true;
  };

  # XXX: Setup ~/.secret/slrn passwords
  system.activationScripts =
  {
    usenet-home =
    {
      deps = [];
      text =
      ''
        su -u usenet -c "ln -sf /etc/user/usenet/slrnrc ~/.slrnrc"
        if [ ! -f /home/usenet/.jnewsrc ];
        then
          su -u usenet -c "slrn --create && slrn -d"
        fi
      '';
    };
  };
}
