{}:

{
  util.acme =
  {
    directory = "/var/lib/acme-unstable";
    plugins = [ "account_reg.json" "account_key.json" "chain.pem" "key.pem" "cert.pem" ];
    post-run =
    ''
      cp -R /var/lib/acme-unstable/* /var/lib/acme/
      systemctl restart httpd.service ;
    '';
  };
}
