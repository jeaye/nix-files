{ config, pkgs, ... }:

{
  # Uploading files via SSH is done through this user and a cron job. Better
  # to not expose the whole http user to SSH.
  users.users.http-upload  =
  {
    isNormalUser = true;
    home = "/etc/user/http-upload";
    extraGroups = [ "ssh-user" ];
  };

  environment.etc =
  {
    "user/http-upload/queue/.manage-directory".text = "";
  };

  environment.etc.user.http-upload.flush =
  {
    text =
    ''
      #!/run/current-system/sw/bin/bash
      set -eu

      files=/etc/user/http-upload/queue/*
      for file in $files;
      do
        mv -f "$file" /etc/user/http/upload.jeaye.com/tmp/
      done

      if [ ! "x$files" = "x" ];
      then
        chown -R http /etc/user/http/upload.jeaye.com/tmp/
      fi
    '';
    mode = "0774";
  };

  # Clean up old files and flush queue regularly.
  services.cron.systemCronJobs =
  [
    "0 0 * * * http ${pkgs.findutils}/bin/find /etc/user/http/upload.jeaye.com/tmp -mtime +2 -type f -exec rm -vf {} \\;"
    "* * * * * root /etc/user/http-upload/flush"
  ];
}
