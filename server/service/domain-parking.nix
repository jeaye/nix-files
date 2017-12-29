{ config, pkgs, ... }:

let
  domains =
  [
    "text-box.org"
    "safetybox.org"
    "univps.org"
    "jank-platform.org"
    "clojure-atlas.org"
    "cpp-atlas.org"
    "history-proxy.org"
    "helderman.io"
    "farmware.io"
    "furthington.com"
    "anylist.io"
    "trustcoin.org"
    "candycapitalist.org"
    "zenlock.org"
    "polyvore.io"
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
      name = "index.html";
      text = builtins.replaceStrings ["%%domain%%"] domain index;
    };
  };
in
{
  services.httpd.virtualHosts = (map makeVirtualHost domains);
  environment.etc = (map makeIndexFile domains);
}
