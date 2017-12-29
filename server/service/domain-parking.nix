{ config, pkgs, ... }:

let
  domains =
  [
    "anylist.io"
    "bankapp.io"
    "candycapitalist.com"
    "candycapitalist.org"
    "clojure-atlas.org"
    "cpp-atlas.org"
    "farmware.io"
    "furthington.com"
    "helderman.io"
    "history-proxy.org"
    "jank-platform.org"
    "jeaye.io"
    "polyvore.io"
    "preplist.io"
    "preplist.org"
    "puretorrent.org"
    "safetybox.org"
    "text-box.org"
    "trustcoin.org"
    "tunnelvpn.io"
    "tunnelvpn.org"
    "univps.org"
    "zenlock.io"
    "zenlock.org"
    "zentrain.io"
  ];
  makeVirtualHost = domain:
  {
    hostName = domain;
    serverAliases = [("www." + domain)];
    enableSSL = false;
    documentRoot = "/etc/user/http/" + domain;
  };
  index = builtins.readFile ./data/park-index.html;
  makeIndexFile = domain:
  {
    name = "user/http/" + domain + "/index.html";
    value =
    {
      text = builtins.replaceStrings ["%%domain%%"] [domain] index;
    };
  };
in
{
  services.httpd.virtualHosts = (map makeVirtualHost domains);
  environment.etc = (builtins.listToAttrs (map makeIndexFile domains));
}
