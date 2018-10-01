{ config, pkgs, ... }:

let
  domains =
  [
    "anonymust.org"
    "anylist.io"
    "autocoupon.org"
    "bankapp.io"
    "candycapitalist.com"
    "candycapitalist.org"
    "clojure-atlas.org"
    "cpp-atlas.org"
    "date-ver.org"
    "datever.org"
    "farmware.io"
    "furthington.com"
    "helderman.io"
    "history-proxy.org"
    "jank-platform.org"
    "jeaye.io"
    "orthodox-lang.com"
    "orthodox-lang.io"
    "orthodox-lang.org"
    "polyvore.io"
    "preplist.io"
    "preplist.org"
    "puretorrent.org"
    "safetybox.org"
    "spamcan.org"
    "text-box.org"
    "trustcoin.org"
    "tunnelvpn.io"
    "tunnelvpn.org"
    "univps.org"
    "unorthodox-lang.com"
    "unorthodox-lang.io"
    "unorthodox-lang.org"
    "unorthodox.io"
    "vingtsun.io"
    "wingtsun.io"
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
