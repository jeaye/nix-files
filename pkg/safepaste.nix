{ stdenv, pkgs, fetchFromGitHub }:

let pkgsUnstable = import
(
  fetchTarball https://github.com/NixOS/nixpkgs-channels/archive/nixos-unstable.tar.gz
)
{ };
in
{
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
    buildInputs = [ pkgsUnstable.boot pkgs.nodejs ];
    installPhase =
    ''
      mkdir -p $out/bin;
      boot build
      install -m 0644 target/safepaste.jar $out/bin/
    '';
  }
}
