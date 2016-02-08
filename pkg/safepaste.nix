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
      rev = "4292d439e10b76e946d94929f60884a184280c95";
      sha256 = "1lz1w4afcdsz4br36smvfcv83skhv4cqhk46xz81g56akc915kfd";
    };
    __noChroot = true;
    buildInputs = [ pkgsUnstable.boot pkgs.nodejs ];
    buildPhase =
    ''
      export BOOT_HOME=$PWD
      export BOOT_LOCAL_REPO=$PWD
      export PATH=${pkgs.nodejs}/bin:$PATH
      ${pkgsUnstable.boot}/bin/boot build
    '';
    installPhase =
    ''
      mkdir -p $out/bin;
      install -m 0644 target/safepaste.jar $out/bin/
    '';
  }
