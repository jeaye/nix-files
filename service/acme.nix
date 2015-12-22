{ config, pkgs, ... }:

let
  global-email = "contact@jeaye.com";
  global-plugins = [ "chain.pem" "key.pem" "cert.pem" ];
  global-post-run =
  ''
    cp -R /var/lib/acme-unstable/* /var/lib/acme/
    systemctl restart httpd.service ;
  '';
in
{
  imports = [ ../pkg/acme.nix ];

  environment.systemPackages = let pkgsUnstable = import
  (
    fetchTarball https://github.com/NixOS/nixpkgs-channels/archive/nixos-unstable.tar.gz
  )
  { };
  in [ pkgsUnstable.simp_le ];

  # XXX: SSL must be disabled per-domain in httpd for the initial certs
  # to be created properly.
  security.acme =
  {
    directory = "/var/lib/acme-unstable";

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
      "fu-er.com" =
      {
        webroot = "/home/http/fu-er.com";
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
        webroot = "/home/http/penelope-art.com";
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
        webroot = "/home/http/penny-art.com";
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
