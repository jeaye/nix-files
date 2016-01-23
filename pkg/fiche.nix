{ stdenv, pkgs, fetchFromGitHub }:

stdenv.mkDerivation rec
{
  name = "fiche";
  src = pkgs.fetchFromGitHub
  {
    owner = "solusipse";
    repo = "fiche";
    rev = "a5c137c06d20e96fb97e946378437ec198299287";
    sha256 = "1371gafnysddg7zip2rdrp3wd8n4xc6ddvkcqfg4b4jc6i2hxxax";
  };
  buildInputs = [];
  installPhase = "mkdir -p $out/bin; install -m 0755 fiche $out/bin/";
}
