{}:

{
  util.http =
  rec {
    # Basic config
    extraConfig =
    ''
      AddDefaultCharset UTF-8
      AddCharset UTF-8 .html .htm .txt

      ServerTokens Prod
      ServerSignature Off
      TraceEnable off

      # Prefer HTTP2
      Protocols h2 h2c http/1.1
    '';

    # Helper functions
    sslInfo = domain: cert_domain:
    ''
      <Directory /etc/user/http/${domain}/.well-known>
        AllowOverride None
        Options MultiViews Indexes SymLinksIfOwnerMatch IncludesNoExec
        Require method GET POST OPTIONS
      </Directory>
      Alias /.well-known/ /etc/user/http/${domain}/.well-known/

      SSLCertificateKeyFile /var/lib/acme/${cert_domain}/key.pem
      SSLCertificateChainFile /var/lib/acme/${cert_domain}/chain.pem
      SSLCertificateFile /var/lib/acme/${cert_domain}/cert.pem
      SSLProtocol All -SSLv2 -SSLv3
      SSLCipherSuite HIGH:!aNULL:!MD5:!EXP
      SSLHonorCipherOrder on
    '';
    ignoreDirectory = domain:
    ''
      <Directory /etc/user/http/${domain}>
      Options -Indexes
      </Directory>
    '';
    domainDefaults = domain: cert_domain: (ignoreDirectory domain)
                                          + (sslInfo domain cert_domain);
  };
}
