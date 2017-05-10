{ stdenv, pkgs, fetchgit }:

stdenv.mkDerivation rec
{
  name = "safepaste";
  src = fetchgit
  {
    url = "https://github.com/jeaye/safepaste.git";
    deepClone = true;
    rev = "838abea423d0842b1a464c2a3d7d5dc4aaf83d98";
    sha256 = "0dhfbrqhmhaaqjcsr94n5szrnvbnsk7zln52g63rv13p57ql33wb";
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
