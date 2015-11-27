{ stdenv, pkgs, fetchFromGitHub }:

stdenv.mkDerivation rec {
  name = "fiche";
  src = pkgs.fetchFromGitHub {
    owner = "solusipse";
    repo = "fiche";
    rev = "8f3e23d3de66aa894f78417523cb6aeb208b6d60";
    sha256 = "1371gafnysddg7zip2rdrp3wd8n4xc6ddvkcqfg4b4jc6i2hxxax";
  };
  buildInputs = [];
  installPhase = "mkdir -p $out/bin; install -m 0755 fiche $out/bin/";
}
