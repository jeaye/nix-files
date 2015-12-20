{ config, pkgs, ... }:

let
  global-email = "contact@jeaye.com";
  global-plugins = [ "chain.pem" "key.pem" "cert.pem" ];
  global-post-run = "systemctl restart httpd.service";
in
{
  imports = [ ../pkg/acme.nix ];

  environment.systemPackages = let pkgsUnstable = import
  (
    fetchTarball https://github.com/NixOS/nixpkgs-channels/archive/nixos-unstable.tar.gz
  )
  { };
  in [ pkgsUnstable.simp_le ];

  security.acme =
  {
    certs =
    {
      "pastespace.org" =
      {
        webroot = "/home/http/pastespace.org";
        extraDomains =
        {
          "www.pastespace.org" = null;
          "mail.pastespace.org" = null;
        };
        email = global-email;
        plugins = global-plugins;
        postRun = global-post-run;
      };
      "mail.jeaye.com" =
      {
        webroot = "/home/http/mail.jeaye.com";
        email = global-email;
        plugins = global-plugins;
        postRun = global-post-run;
      };
      "fu-er.com" =
      {
        webroot = "/home/http/fu-er.com";
        extraDomains =
        {
          "www.fu-er.com" = null;
          "mail.fu-er.com" = null;
        };
        email = global-email;
        plugins = global-plugins;
        postRun = global-post-run;
      };
      "penelope-art.com" =
      {
        webroot = "/home/http/penelope-art.com";
        extraDomains =
        {
          "www.penelope-art.com" = null;
          "mail.penelope-art.com" = null;

          "penny-art.com" = null;
          "www.penny-art.com" = null;
          "mail.penny-art.com" = null;
        };
        email = global-email;
        plugins = global-plugins;
        postRun = global-post-run;
      };
      "penny-art.com" =
      {
        webroot = "/home/http/penny-art.com";
        extraDomains =
        {
          "www.penny-art.com" = null;
          "mail.penny-art.com" = null;
        };
        email = global-email;
        plugins = global-plugins;
        postRun = global-post-run;
      };
    };
  };
}
