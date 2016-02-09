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
      sha256 = "0j9sgn3rqvb014aryyy54famal5m9xj2qzsffwd0qym3q8ja5ikq";
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
      mkdir -p $out/bin;
      install -m 0644 target/safepaste.jar $out/bin/
      install -m 0755 tool/clean-expired $out/bin/
    '';
  }
