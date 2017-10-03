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
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQD0cNcqr6VeQjQqtwhxE0IcqpQo+jULXbmKsyILFoigP5chpCVKv9qYUqk5mTjiLH9TzsC17z6CIOHGIXCxZABqpAXrPoHe8kn3WXYX04l4PWRTzeuUg2SIhTv0CwUDZGCnaTVlGpLd6CCHFbxp/4fDQ4C53NdBVu0zGeuRACutF+OTpGgsdJ8JyDBn8z9+IMgxMM1K2C5geiz2arNpQJDbu/RvZBO7bD2JDUKBRkNAv986vNdpgZvrVUR3Jhg7RVPQEioVg7jF3WmOHwMX8pYlL7Nk4tLHIfOj02Gh2FsSq8aYgTsYD4+a5A4ZSmJlP1is3N6+lu/hIcITF8A8nBBNAPIKfSY1HD5XMgjObQudtCvF15LACJgtrCV7HCIcfWklra7DcQsfcuKHGMFWDFjCer7lbUIBAeV7QbNhR/H5H3vu2kTN94myStCCmjs3KzgztP/UKWEKyes7a8+7LcUwu/zHxTw/9xTFVf5YW40gMEfuS3IFJzLf5s2yK0jd91rDEtWd+/uFqLcgjFxhd75Y/JmWYgpNRfpEva+N8A3aDrJ1t/GKUtz4AhT+D1Iu0lmJOdAvjnolbruFC3LnQxnYvlifrkRv4knjW7UA2+KEKTmHhggdJoEORsgfTDcG99Kv/PXeheY/JrGeHzJvJ7RssbxlXD8WC71FKKtmJStCyQ== pwilkerson@uber.com"
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

        queue=/etc/user/http-upload/queue

        # Check if it's empty first
        if [ ".manage-directory" = "$(ls -A $queue)" ];
        then
          exit 0
        fi

        for file in $queue/*;
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
