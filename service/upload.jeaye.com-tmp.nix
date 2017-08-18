{ config, pkgs, ... }:

{
  # Uploading files via SSH is done through this user and a cron job. Better
  # to not expose the whole http user to SSH.
  users.users.http-upload  =
  {
    isNormalUser = true;
    home = "/etc/user/http-upload";
    extraGroups = [ "ssh-user" ];
    openssh.authorizedKeys.keys =
    [
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDL8j6NtvibZpsDLWSjsPMIjUQRYHta/a8XpOJf7CQ2Aze73oFwBPaAvP1iSmpLkFCs0hp+8w0P4+eHAjp67mLgVLIvM0iESpj8YbVJACyL2Gu2J8fN63CFP3HAMEmvXGK8LSpBEErF44az0H8ZrMJPODkUYiQMX2kAgshUjtMaUqicZmWRRsiJ8bBcK2ddsWOXPzY/0j8+9KMre8YaFJve/QgmJEvVpdxt8pqklPCiMHjFI0EKRHV835mDLe/fzYK2hrTzRXw5hRpluonGce7Tg7WsVk/SmGdfysJAYOOvUwcLosK64bsg2+wIdEKG4r/Ws9FR2hqykspzx4s2o6jL jeaye@oryx"
    ];
  };

  environment.etc =
  {
    "user/http-upload/queue/.manage-directory".text = "";
    "user/http-upload/flush" =
    {
      text =
      ''
        #!/run/current-system/sw/bin/bash
        set -eu

        for file in $(find /etc/user/http-upload/queue/ -maxdepth 1);
        do
          basename=$(basename "$file")
          mv -f "$file" /etc/user/http/upload.jeaye.com/tmp/
          chown -R http /etc/user/http/upload.jeaye.com/tmp/"$basename"
        done
      '';
      mode = "0774";
    };
  };

  # Clean up old files and flush queue regularly.
  services.cron.systemCronJobs =
  [
    "0 0 * * * http ${pkgs.findutils}/bin/find /etc/user/http/upload.jeaye.com/tmp -mtime +2 -type f -exec rm -vf {} \\;"
    "* * * * * root /etc/user/http-upload/flush"
  ];
}
