{ stdenv, pkgs, fetchFromGitHub }:

stdenv.mkDerivation rec
{
  name = "safepaste";
  src = pkgs.fetchFromGitHub
  {
    owner = "jeaye";
    repo = "safepaste";
    rev = "cbaf3939970cf2e5964946dcad001330d4ee5324";
    sha256 = "0kvywffrh4723051ndyb5zzb81bcc5x5q2qpkp26m9g65q8xdf82";
  };
  buildInputs = [ boot nodejs ];
  installPhase =
  ''
    mkdir -p $out/bin;
    boot build
    install -m 0644 target/safepaste.jar $out/bin/
  '';
}
