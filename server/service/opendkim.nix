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
        Domain                  pastespace.org safepaste.org jeaye.com fu-er.com penelope-art.com penny-art.com
        Selector                mail
        KeyTable                refile:/etc/opendkim/key-table
        SigningTable            refile:/etc/opendkim/signing-table
        Socket                  local:/var/run/opendkim/opendkim.sock
        ReportAddress           postmaster@pastespace.org
        RequireSafeKeys         False
        UserID                  opendkim:opendkim

        AutoRestart             Yes
        AutoRestartRate         10/1h
        UMask                   002
        Syslog                  yes
        SyslogSuccess           Yes
        LogWhy                  Yes

        Canonicalization        relaxed/simple
      '';
    };
    "opendkim/key-table" =
    {
      text =
      ''
        mail._domainkey.pastespace.org pastespace.org:mail:/etc/opendkim/keys/pastespace.org/mail.private
        mail._domainkey.safepaste.org safepaste.org:mail:/etc/opendkim/keys/safepaste.org/mail.private
        mail._domainkey.jeaye.com jeaye.com:mail:/etc/opendkim/keys/jeaye.com/mail.private
        mail._domainkey.fu-er.com fu-er.com:mail:/etc/opendkim/keys/fu-er.com/mail.private
        mail._domainkey.penelope-art.com penelope-art.com:mail:/etc/opendkim/keys/penelope-art.com/mail.private
        mail._domainkey.penny-art.com penny-art.com:mail:/etc/opendkim/keys/penny-art.com/mail.private
      '';
    };
    "opendkim/signing-table" =
    {
      text =
      ''
        *@pastespace.org mail._domainkey.pastespace.org
        *@safepaste.org mail._domainkey.safepaste.org
        *@jeaye.com mail._domainkey.jeaye.com
        *@fu-er.com mail._domainkey.fu-er.com
        *@penelope-art.com mail._domainkey.penelope-art.com
        *@penny-art.com mail._domainkey.penny-art.com
      '';
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
        mkdir -p /var/run/opendkim
        chown -R opendkim:opendkim /var/run/opendkim

        work()
        {
          if [ ! -f /etc/opendkim/keys/$1/mail.private ];
          then
            mkdir -p /etc/opendkim/keys/$1
            ${pkgs.opendkim}/bin/opendkim-genkey -d $1 -D /etc/opendkim/keys/$1/ -s mail -r -t
          fi
        }
        for domain in pastespace.org safepaste.org jeaye.com fu-er.com penelope-art.com penny-art.com;
        do
          work $domain
        done

        chmod -R 700 /etc/opendkim/keys
        chown -R opendkim:opendkim /etc/opendkim/keys
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
