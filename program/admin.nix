{ config, pkgs, ... }:

{
  # Some helpful scripts and packages for diagnostics
  environment.systemPackages = with pkgs;
  [
    pcre
  ];

  # TODO: Add a script for watching failed email logins
  # TODO: Script for daily emails sent/recieved per user
  environment.etc =
  {
    "admin/daily-failed-ssh-logins" =
    {
      text =
      ''
        #!/run/current-system/sw/bin/bash
        set -eu

        title="Failed SSH logins"
        printf "%*s\n\n" $(((''${#title}+$COLUMNS)/2)) "$title"
        journalctl -u sshd | grep 'Failed password' \
                           | awk '{print $1,$2}' \
                           | sort -k 1,1M -k 2n \
                           | uniq -c \
                           | sed -e 's/^\s\+//g' \
                                 -e 's/\(\S\+\) \+\(\S\+\) \+\(\S\+\)/\2 \3\t\t= \1/'
      '';
      mode = "0774";
    };
    "admin/daily-succeeded-ssh-logins" =
    {
      text =
      ''
        #!/run/current-system/sw/bin/bash
        set -eu

        title="Accepted SSH logins"
        printf "%*s\n\n" $(((''${#title}+$COLUMNS)/2)) "$title"
        journalctl -u sshd \
          | grep 'Accepted' \
          | sed 's/\(\S\+\) \(\S\+\).*for \(\S\+\) from.*/\1 \2 \3/' \
          | uniq \
          | tr '\n' '|' \
          | sed -e ':loop' \
                -e 's/\(\S\+\) \(\S\+\) \(.\+\)|\1 \2 \(\S\+\)/\1 \2 \3 \4/g' \
                -e 't loop' \
          | tr '|' '\n' \
          | sed -e 's/\(\S\+\) \+\(\S\+\) \+\(.\+\)/\1 \2\t\t= \3/'
      '';
      mode = "0774";
    };
    "admin/daily-port-scans" =
    {
      text =
      ''
        #!/run/current-system/sw/bin/bash
        set -eu

        title="Port scans detected"
        printf "%*s\n\n" $(((''${#title}+$COLUMNS)/2)) "$title"
        journalctl | grep 'rejected connection:' \
                   | awk '{print $1,$2}' \
                   | sort -k 1,1M -k 2n \
                   | uniq -c \
                   | sed -e 's/^\s\+//g' \
                         -e 's/\(\S\+\) \+\(\S\+\) \+\(\S\+\)/\2 \3\t\t= \1/'
      '';
      mode = "0774";
    };
    "admin/daily-postfix-dos" =
    {
      text =
      ''
        #!/run/current-system/sw/bin/bash
        set -eu

        title="Postfix DOS attempts"
        printf "%*s\n\n" $(((''${#title}+$COLUMNS)/2)) "$title"
        journalctl -u postfix | grep 'lost connection after EHLO from' \
                              | awk '{print $1,$2}' \
                              | sort -k 1,1M -k 2n \
                              | uniq -c \
                              | sed -e 's/^\s\+//g' \
                                    -e 's/\(\S\+\) \+\(\S\+\) \+\(\S\+\)/\2 \3\t\t= \1/'
      '';
      mode = "0774";
    };
    "admin/rejected-emails" =
    {
      text =
      ''
        #!/run/current-system/sw/bin/bash
        set -eu

        title="Rejected emails"
        printf "%*s\n\n" $(((''${#title}+$COLUMNS)/2)) "$title"

        regex="reject: .+\[(.+)\]: .+ (from=<.+>) (to=<.+>) .+ (helo=<.+>).*"
        rejected=$(journalctl -u postfix \
                    | pcregrep -o1 -o2 -o3 --om-separator '|' "$regex")
        count=$(wc -l <<< "$rejected")
        unique=$(sort -u <<< "$rejected" | wc -l)
        last=$(sed 's/|/\n\t/g' <<< "$rejected" | tail -15)

        printf "Total: $count\nUnique: $unique\n\n$last\n"
      '';
      mode = "0774";
    };
    "admin/daily-valid-safepaste" =
    {
      text =
      ''
        #!/run/current-system/sw/bin/bash
        set -eu

        title="Valid safepaste submissions"
        printf "%*s\n\n" $(((''${#title}+$COLUMNS)/2)) "$title"
        journalctl -u safepaste | egrep 'Paste from .+ for .+ is valid.' \
                                | awk '{print $1,$2}' \
                                | sort -k 1,1M -k 2n \
                                | uniq -c \
                                | sed -e 's/^\s\+//g' \
                                      -e 's/\(\S\+\) \+\(\S\+\) \+\(\S\+\)/\2 \3\t\t= \1/' \
                                | tail -5
      '';
      mode = "0774";
    };
    "admin/monthly-http-access" =
    {
      text =
      ''
        #!/run/current-system/sw/bin/bash
        set -eu

        month=$1 # Mar, Jun, etc
        site=$2 # jeaye.com, safepaste.org, etc
        year=$(date +"%Y")

        views=$(grep "$month/$year" /var/log/httpd/access_log-$site \
                     | pcregrep -o1 "GET (\/|\/\S*\/)(?:\?.*)? HTTP\/\S+\" 200" \
                     | egrep -v "\.(css|png|js|txt|xml|well-known)" \
                     | wc -l)

        printf "$month $year $site : $views\n"
      '';
      mode = "0774";
    };
    "admin/monthly-http-favorites" =
    {
      text =
      ''
        #!/run/current-system/sw/bin/bash
        set -eu

        month=$1 # Mar, Jun, etc
        site=$2 # jeaye.com, safepaste.org, etc
        year=$(date +"%Y")

        views=$(grep "$month/$year" /var/log/httpd/access_log-$site \
                    | pcregrep -o1 "GET (\/|\/\S*\/)(?:\?.*)? HTTP\/\S+\" 200" \
                    | egrep -v "\.(css|png|js|txt|xml|well-known)" \
                    | sort \
                    | uniq -c \
                    | sort -n)

        echo "$month $year $site :"
        echo "$views"
      '';
      mode = "0774";
    };
    "admin/unban-fail2ban-ip" =
    {
      text =
      ''
        #!/run/current-system/sw/bin/bash
        set -eu

        jails=$(fail2ban-client status | pcregrep -o1 "list:\s*(\w.*)" | sed 's/,//g')
        for jail in $jails;
        do
          echo "Removing $1 from $jail"
          fail2ban-client set $jail unbanip $1 > /dev/null 2>&1 || true
        done
      '';
      mode = "0774";
    };
    "admin/optimize-nix" =
    {
      text =
      ''
        #!/run/current-system/sw/bin/bash
        set -eu

        # Delete everything from this profile that isn't currently needed
        nix-env --delete-generations old

        # Delete generations older than a week
        nix-collect-garbage
        nix-collect-garbage --delete-older-than 7d

        # Optimize
        nix-store --gc --print-dead
        nix-store --optimise
      '';
      mode = "0774";
    };
  };
}
