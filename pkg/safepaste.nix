{ stdenv, pkgs, fetchgit }:

stdenv.mkDerivation rec
{
  name = "safepaste";
  src = fetchgit
  {
    url = "https://github.com/jeaye/safepaste.git";
    deepClone = true;
    rev = "c4bc8af889c8ab43e7fcb4f0c0e100682d165d17";
    sha256 = "1rg6ay68xnmz3pxgm7mgd4bcyra8z1s519lwx3gxciga1qyxb3z0";
  };
  buildInputs = [ pkgs.boot pkgs.nodejs ];
  buildPhase =
  ''
    # For boot
    export BOOT_HOME=$PWD
    export BOOT_LOCAL_REPO=$PWD

    # For npm
    export HOME=$PWD

    ${pkgs.boot}/bin/boot build
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
