{ config, pkgs, pythonPackages, ... }:

let
  global-email = "contact@jeaye.com";
  global-plugins = [ "account_key.json" "chain.pem" "key.pem" "cert.pem" ];
  global-post-run =
  ''
    cp -R /var/lib/acme-unstable/* /var/lib/acme/
    systemctl restart httpd.service ;
  '';
in
{
  environment.systemPackages = [ pkgs.simp_le ];

  nixpkgs.config =
  {
    packageOverrides = pkgs: rec
    {
      simp_le = pkgs.stdenv.lib.overrideDerivation pkgs.simp_le (oldAttrs:
      {
        version = "0.2.0";
        src = pythonPackages.fetchPypi
        {
          pname = "simp_le-client";
          version = "0.2.0";
          sha256 = "18y8mg0s0i2bs57pi6mbkwgjlr5mmivchiyvrpcbdmkg9qlbfwaa";
        };
        patches = [];
      });
    };
  };

  security.acme =
  {
    directory = "/var/lib/acme-unstable";

    certs =
    {
      "pastespace.org" =
      {
        webroot = "/etc/user/http/pastespace.org";
        extraDomains =
        {
          "www.pastespace.org" = null;
          "mail.pastespace.org" = null;
          "webmail.pastespace.org" = null;
        };
        email = global-email;
        plugins = global-plugins;
        postRun = global-post-run;
      };
      "safepaste.org" =
      {
        webroot = "/etc/user/http/safepaste.org";
        extraDomains =
        {
          "www.safepaste.org" = null;
          "mail.safepaste.org" = null;
        };
        email = global-email;
        plugins = global-plugins;
        postRun = global-post-run;
      };
      "jeaye.com" =
      {
        webroot = "/etc/user/http/jeaye.com";
        extraDomains =
        {
          "www.jeaye.com" = null;
          "upload.jeaye.com" = null;
          "blog.jeaye.com" = null;
        };
        email = global-email;
        plugins = global-plugins;
        postRun = global-post-run;
      };
      "fu-er.com" =
      {
        webroot = "/etc/user/http/fu-er.com";
        extraDomains =
        {
          "www.fu-er.com" = null;
        };
        email = global-email;
        plugins = global-plugins;
        postRun = global-post-run;
      };
      "penelope-art.com" =
      {
        webroot = "/etc/user/http/penelope-art.com";
        extraDomains =
        {
          "www.penelope-art.com" = null;
        };
        email = global-email;
        plugins = global-plugins;
        postRun = global-post-run;
      };
      "penny-art.com" =
      {
        webroot = "/etc/user/http/penny-art.com";
        extraDomains =
        {
          "www.penny-art.com" = null;
        };
        email = global-email;
        plugins = global-plugins;
        postRun = global-post-run;
      };
    };
  };
}
