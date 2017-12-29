{ config, pkgs, ... }:

let
  domains = [];
in
{
  services.httpd =
  {
    virtualHosts =
    [
      {
        hostName = "bankapp.io";
        serverAliases =
        [
          "www.bankapp.io"
        ];
        enableSSL = false;
        documentRoot = "/etc/user/http/bankapp.io";
      }
    ];
  };
}
