{ stdenv, pkgs, fetchgit }:

let
  pkgsUnstable = import
  (
    fetchTarball https://github.com/NixOS/nixpkgs-channels/archive/nixos-unstable.tar.gz
  ) { };
in
  stdenv.mkDerivation rec
  {
    name = "safepaste";
    src = fetchgit
    {
      url = "https://github.com/jeaye/safepaste.git";
      deepClone = true;
      rev = "cbaf3939970cf2e5964946dcad001330d4ee5324";
      sha256 = "1lz1w4afcdsz4br36smvfcv83skhv4cqhk46xz81g56akc915kfd";
    };
    buildInputs = [ pkgsUnstable.boot pkgs.nodejs ];
    buildPhase =
    ''
      export BOOT_HOME=$PWD
      export BOOT_LOCAL_REPO=$PWD
      ${pkgsUnstable.boot}/bin/boot build
    '';
    installPhase =
    ''
      mkdir -p $out/bin;
      install -m 0644 target/safepaste.jar $out/bin/
    '';
  }
