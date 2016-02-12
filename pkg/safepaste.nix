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
      rev = "8d4e89e7654c4757bf4ee0f6a9ed5491b59ff613";
      sha256 = "12c4w7ia7yx32p8jv6ng8zb2l78jsx1ffycwhdd8kkb6gb2mpw84";
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
      install -m 0755 tool/ban $out/bin/
      install -m 0644 src/paste/about $out/share/
      install -m 0644 src/paste/donate $out/share/
    '';
  }
