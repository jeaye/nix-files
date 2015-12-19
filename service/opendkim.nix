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
        Domain                  pastespace.org fu-er.com
        Selector                mail
        KeyTable                /etc/opendkim/key-table
        SigningTable            /etc/opendkim/signing-table
        Socket                  local:/var/run/opendkim/opendkim.sock
        UMask                   002
        ReportAddress           postmaster@pastespace.org
        RequireSafeKeys         False
        UserID                  opendkim:opendkim
      '';
    };
    "opendkim/key-table" =
    {
      text =
      ''
        KEYS		            VALUES
        ----		            ------
        pastespace		      pastespace.org
                            mail
                            /etc/opendkim/keys/pastespace.org/mail.private

        fu-er		            fu-er.com
                            mail
                            /etc/opendkim/keys/pastespace.org/mail.private
      '';
    };
    "opendkim/signing-table" =
    {
      text =
      ''
        KEYS		            VALUES
        ----		            ------
        pastespace.org	    pastespace
        fu-er.com	          fu-er
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
        for domain in pastespace.org fu-er.com;
        do
          work $domain
        done

        chmod -R 660 /etc/opendkim/keys
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
