{
  util.http =
  {
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
  };
}
