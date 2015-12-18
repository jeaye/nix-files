{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs;
  [
    opendkim
    openssl
  ];

  environment.etc =
  {
    "opendkim/opendkim.conf" =
    {
      text =
      ''
        Domain                  pastespace.org
        Selector                mail
        KeyFile                 /etc/opendkim/keys/pastespace.org/mail.private
        Socket                  local:/var/run/opendkim/opendkim.sock
        UMask                   002
        ReportAddress           postmaster@pastespace.org
        RequireSafeKeys         False
        UserID                  opendkim:opendkim
      '';
      mode = "0774";
    };
  };

  system.activationScripts =
  {
    opendkim =
    {
      deps = [];
      text =
      ''
        export PATH=${pkgs.stdenv}/bin:${pkgs.openssl}/bin:${pkgs.gnused}/bin:${pkgs.gnugrep}/bin:$PATH
        mkdir -p /var/run/opendkim /etc/opendkim/keys/pastespace.org
        chown -R opendkim:opendkim /var/run/opendkim
        if [ ! -f /etc/opendkim/keys/pastespace.org/mail.private ];
        then
          ${pkgs.opendkim}/bin/opendkim-genkey -d pastespace.org -D /etc/opendkim/keys/pastespace.org/ -s mail -r -t
          chown -R opendkim:opendkim /etc/opendkim/keys/pastespace.org
          chmod -R 660 /etc/opendkim/keys
        fi
      '';
    };
  };

  systemd.services.opendkim =
  {
    wantedBy = [ "multi-user.target" ];
    after = [ "network.target" ];
    serviceConfig =
    {
      ExecStart =
      ''
        ${pkgs.opendkim}/bin/opendkim -f -x /etc/opendkim/opendkim.conf
      '';
    };
  };

  users.users.opendkim =
  {
    isSystemUser = true;
    extraGroups = [ "opendkim" ];
  };
  users.users.postfix.extraGroups = [ "opendkim" ];
  users.groups.opendkim = {};
}
