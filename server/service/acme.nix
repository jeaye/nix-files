{ config, pkgs, ... }:

with import ../util/acme.nix {};

let
  global-email = "contact@jeaye.com";
in
{
  environment.systemPackages = [ pkgs.simp_le ];

  security.acme =
  {
    directory = util.acme.directory;

    # TODO: Combine these subdomains where possible
    certs =
    {
      "pastespace.org" =
      {
        webroot = "/etc/user/http/pastespace.org";
        extraDomains =
        {
          "www.pastespace.org" = null;
          "mail.pastespace.org" = null;
          #"cloud.pastespace.org:/etc/user/http/cloud.pastespace.org" = null;
          "webmail.pastespace.org:/etc/user/http/webmail.pastespace.org" = null;
        };
        email = global-email;
        plugins = util.acme.plugins;
        postRun = util.acme.post-run + "systemctl restart dovecot2;";
      };
      "safepaste.org" =
      {
        webroot = "/etc/user/http/safepaste.org";
        extraDomains =
        {
          "www.safepaste.org" = null;
        };
        email = global-email;
        plugins = util.acme.plugins;
        postRun = util.acme.post-run;
      };
      "jeaye.com" =
      {
        webroot = "/etc/user/http/jeaye.com";
        extraDomains =
        { "www.jeaye.com" = null; };
        email = global-email;
        plugins = util.acme.plugins;
        postRun = util.acme.post-run;
      };
      "upload.jeaye.com" =
      {
        webroot = "/etc/user/http/upload.jeaye.com";
        extraDomains =
        { "upload.jeaye.com" = null; };
        email = global-email;
        plugins = util.acme.plugins;
        postRun = util.acme.post-run;
      };
      "jank-lang.org" =
      {
        webroot = "/etc/user/http/jank-lang.org";
        extraDomains =
        {
          "www.jank-lang.org" = null;
          "bench.jank-lang.org" = null;
        };
        email = global-email;
        plugins = util.acme.plugins;
        postRun = util.acme.post-run;
      };
      "fu-er.com" =
      {
        webroot = "/etc/user/http/fu-er.com";
        extraDomains =
        {
          "www.fu-er.com" = null;
        };
        email = global-email;
        plugins = util.acme.plugins;
        postRun = util.acme.post-run;
      };
      "penelope-art.com" =
      {
        webroot = "/etc/user/http/penelope-art.com";
        extraDomains =
        {
          "www.penelope-art.com" = null;
        };
        email = global-email;
        plugins = util.acme.plugins;
        postRun = util.acme.post-run;
      };
      "penny-art.com" =
      {
        webroot = "/etc/user/http/penny-art.com";
        extraDomains =
        {
          "www.penny-art.com" = null;
        };
        email = global-email;
        plugins = util.acme.plugins;
        postRun = util.acme.post-run;
      };
    };
  };
}
