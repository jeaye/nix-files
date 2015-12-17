{ config, pkgs, ... }:

{
  # Some helpful scripts
  environment.etc =
  {
    "admin/daily-failed-ssh-logins" =
    {
      text =
      ''
        journalctl -u sshd | grep 'Failed password' \
                           | grep sshd \
                           | awk '{print $1,$2}' \
                           | sort -k 1,1M -k 2n \
                           | uniq -c
      '';
      mode = "0774";
    };
    "admin/daily-port-scans" =
    {
      text =
      ''
        journalctl | grep 'rejected connection:' \
                   | awk '{print $1,$2}' \
                   | sort -k 1,1M -k 2n \
                   | uniq -c
      '';
      mode = "0774";
    };
  };
}
