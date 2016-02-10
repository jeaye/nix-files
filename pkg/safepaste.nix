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
      rev = "8b638f113bb06aed92a8c18b2cd910d366a15d8a";
      sha256 = "0qdswfjqml528rvavgz0n4jnzl5syjhb0i8fhg4cbw9vriqv3vgb";
    };
    __noChroot = true;
    buildInputs = [ pkgsUnstable.boot pkgs.nodejs ];
    buildPhase =
    ''
      # For boot
      export BOOT_HOME=$PWD
      export BOOT_LOCAL_REPO=$PWD

      # For npm
      export HOME=$PWD

      ${pkgsUnstable.boot}/bin/boot build
    '';
    installPhase =
    ''
      mkdir -p $out/{bin,share}
      install -m 0644 target/safepaste.jar $out/bin/
      install -m 0755 tool/clean-expired $out/bin/
      install -m 0755 tool/encrypt $out/bin/
      install -m 0644 src/paste/about $out/share/
      install -m 0644 src/paste/donate $out/share/
    '';
  }
