{ config, pkgs, ... }:

{
  users.users.fu-er =
  {
    isNormalUser = true;
    home = "/etc/user/fu-er";
    extraGroups = [ "ssh" ];
  };

  environment.etc =
  {
    "user/fu-er/.procmailrc" =
    {
      text =
      ''
        INCLUDERC=/etc/user/fu-er/.procmail/spam.rc
      '';
    };
    "user/fu-er/.procmail/spam.rc" =
    {
      text =
      ''
        # TrueIdentity
        :0:
        * ^From: trueidentity@e-tui.transunion.com
        .Trash/

        # Junk
        :0:
        * ^From|Cc|To|X-Original-To: kitty@pastespace\.org
        .Junk/
      '';
    };
  };
}
