{ config, pkgs, lib, ... }:

{
  environment.systemPackages = with pkgs;
  [
    imapfilter
    bogofilter
  ];

  environment.etc =
  {
    "user/jeaye/.imapfilter/config.lua" =
    {
      text = lib.readFile ./data/imap-filter-config.lua;
    };
    "user/jeaye/teach-bogofilter" =
    {
      text =
      ''
        ${pkgs.bogofilter}/bin/bogofilter -Bnv ~/Maildir/.Ham ~/Maildir/.ML*
        ${pkgs.bogofilter}/bin/bogofilter -Bsv ~/Maildir/.Spam
      '';
      mode = "0774";
    };
  };

  system.activationScripts =
  {
    jeaye-imap-filter =
    {
      deps = [];
      text =
      ''
        mkdir -p /etc/user/jeaye/.secret
        chown -R jeaye:users /etc/user/jeaye/{.secret,.imapfilter}
        chmod -R 0700 /etc/user/jeaye/.secret
      '';
      # XXX:
      #   Create pass file in .secret
      #   Run imapfilter once imperatively to accept the SSL cert
    };
  };

  # Run imap-filter regularly
  services.cron.systemCronJobs =
  [
    "*/5 * * * * jeaye ${pkgs.imapfilter}/bin/imapfilter > /dev/null 2>&1"
    "0 */1 * * * jeaye /etc/user/jeaye/teach-bogofilter"
  ];
}
