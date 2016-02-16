{ config, pkgs, ... }:

{
  environment.systemPackages = let pkgsUnstable = import
  (
    fetchTarball https://github.com/NixOS/nixpkgs-channels/archive/nixos-unstable.tar.gz
  )
  { };
  in
  [
    pkgsUnstable.boot
    pkgs.nodejs
    pkgs.openjdk
  ];

  nixpkgs.config =
  {
    packageOverrides = pkgs: rec
    {
      safepaste = pkgs.callPackage ../pkg/safepaste.nix { };
    };
  };

  environment.etc."user/safepaste/run-server" =
  {
    text =
    ''
      #!/run/current-system/sw/bin/bash
      set -eu
      export PATH=${pkgs.openssl}/bin:$PATH

      cd /etc/user/safepaste
      for p in about donate;
      do
        ${pkgs.safepaste}/bin/encrypt $p ${pkgs.safepaste}/share /etc/user/safepaste/paste
      done
      ${pkgs.openjdk}/bin/java -jar ${pkgs.safepaste}/bin/safepaste.jar
    '';
    mode = "0775";
  };

  systemd.services.safepaste =
  {
    wantedBy = [ "multi-user.target" ];
    after = [ "network.target" ];
    serviceConfig =
    {
      User = "safepaste";
      WorkingDirectory = "/etc/user/safepaste";
      ExecStart = "/etc/user/safepaste/run-server";
    };
  };

  services.cron =
  {
    systemCronJobs =
    [
      "*/5 * * * * safepaste /etc/user/safepaste/clean-expired /etc/user/safepaste/paste"
    ];
  };


  users.users.safepaste =
  {
    isNormalUser = false;
    home = "/etc/user/safepaste";
    createHome = true;
  };
  environment.etc."user/safepaste/paste/.manage-directory".text = "";

  system.activationScripts =
  {
    safepaste-home =
    {
      deps = [];
      text =
      ''
        chown -R safepaste:users /etc/user/safepaste
      '';
    };
  };

  networking.firewall.allowedTCPPorts = [ 3000 ];

  services.fail2ban =
  {
    jails.safepaste =
    ''
      filter   = safepaste
      maxretry = 10
      findtime = 43200
      action   = safepaste
      bantime  = 43200
      enabled  = true
    '';
  };

  environment.etc."fail2ban/filter.d/safepaste.conf".text =
  ''
    [Definition]
    failregex = Paste from <HOST> .*
  '';
  environment.etc."fail2ban/action.d/safepaste.conf".text =
  ''
    [Definition]
    actionstart = touch /var/tmp/safepaste.ban
                  chmod a+r /var/tmp/safepaste.ban
    actionstop = sed -i '/.*/d' /var/tmp/safepaste.ban
    actioncheck =
    actionban = ${pkgs.safepaste}/bin/ban add <ip> /var/tmp
    actionunban = ${pkgs.safepaste}/bin/ban remove <ip> /var/tmp
  '';
  environment.etc."user/safepaste/clean-expired" =
  {
    text =
    ''
      #!/usr/bin/env bash

      set -eu

      dir="$(cd "$(dirname "''${BASH_SOURCE[0]}")" && pwd)"

      function usage
      {
        echo "usage: $0 <paste directory>"
        exit 1
      }

      [ ! $# -eq 1 ] && usage

      for paste in $(find "$1" -mmin +0 -type f | egrep -v 'burn|disable');
      do
        [ -w "$paste" ] && rm -fv "$paste" "$paste.burn"
      done
    '';
    mode = "0774";
  };
}
