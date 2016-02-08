{ stdenv, pkgs, fetchFromGitHub }:

let
  pkgsUnstable = import
  (
    fetchTarball https://github.com/NixOS/nixpkgs-channels/archive/nixos-unstable.tar.gz
  ) { };
in
  stdenv.mkDerivation rec
  {
    name = "safepaste";
    src = pkgs.fetchFromGitHub
    {
      owner = "jeaye";
      repo = "safepaste";
      rev = "cbaf3939970cf2e5964946dcad001330d4ee5324";
      sha256 = "1ax8pnaa0l7cr2sya50gjvhfr4j401vw70q973ms5mla95l6zqvh";
    };
    buildInputs = [ pkgsUnstable.boot pkgs.nodejs ];
    installPhase =
    ''
      mkdir -p $out/bin;
      boot build
      install -m 0644 target/safepaste.jar $out/bin/
    '';
  }
