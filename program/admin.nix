{ config, pkgs, ... }:

{
  # Some helpful scripts
  environment.etc =
  {
    "admin/daily-failed-ssh-logins" =
    {
      text =
      ''
        #!/run/current-system/sw/bin/bash
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
        #!/run/current-system/sw/bin/bash
        journalctl | grep 'rejected connection:' \
                   | awk '{print $1,$2}' \
                   | sort -k 1,1M -k 2n \
                   | uniq -c
      '';
      mode = "0774";
    };
    "admin/unban-fail2ban-ip" =
    {
      text =
      ''
        #!/run/current-system/sw/bin/bash
        for jail in port-scan ssh-iptables;
        do
          fail2ban-client set $jail unbanip $1 || true
        done
      '';
      mode = "0774";
    };
  };
}
