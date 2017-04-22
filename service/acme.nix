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
  nixpkgs.config =
  {
    packageOverrides = pkgs: rec
    {
      simp_le = pkgs.callPackage ../pkg/simp_le.nix { };
    };
  };
  environment.systemPackages = [ pkgs.simp_le ];

  # TODO: Combine these subdomains where possible
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
        { "www.jeaye.com" = null; };
        email = global-email;
        plugins = global-plugins;
        postRun = global-post-run;
      };
      "upload.jeaye.com" =
      {
        webroot = "/etc/user/http/upload.jeaye.com";
        extraDomains =
        { "upload.jeaye.com" = null; };
        email = global-email;
        plugins = global-plugins;
        postRun = global-post-run;
      };
      "blog.jeaye.com" =
      {
        webroot = "/etc/user/http/blog.jeaye.com";
        extraDomains =
        { "blog.jeaye.com" = null; };
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
