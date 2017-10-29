{ stdenv, pkgs, fetchgit }:

stdenv.mkDerivation rec
{
  name = "safepaste";
  src = fetchgit
  {
    url = "https://github.com/jeaye/safepaste.git";
    deepClone = true;
    rev = "28c4ed7ca2725e0412f68ef038c7f8cd9e24209e";
    sha256 = "00ryzn768x158xkq1kqh9qyg8ka9dfpchswfz4w0b2mi4mb72bma";
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
