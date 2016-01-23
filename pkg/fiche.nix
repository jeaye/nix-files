{ stdenv, pkgs, fetchFromGitHub }:

stdenv.mkDerivation rec
{
  name = "fiche";
  src = pkgs.fetchFromGitHub
  {
    owner = "solusipse";
    repo = "fiche";
    rev = "a5c137c06d20e96fb97e946378437ec198299287";
    sha256 = "0kvywffrh4723051ndyb5zzb81bcc5x5q2qpkp26m9g65q8xdf8";
  };
  buildInputs = [];
  installPhase = "mkdir -p $out/bin; install -m 0755 fiche $out/bin/";
}
