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
      rev = "30d36a9d652d0d3cb67595f269c0d5de80386958";
      sha256 = "10vh0nz8njkxh7jnwhd4fyqm4nwg6l1zpqsdaqnlsk656payc3yz";
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
