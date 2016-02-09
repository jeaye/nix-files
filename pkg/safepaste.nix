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
      rev = "5ed4ce938c2d0872ceda292b050600e5bf542057";
      sha256 = "1j650lxn3a0ndjzkfd8kznwiwwlrp6fk7vc7g1rap9fwf4r0izrn";
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
