{ stdenv, pkgs, fetchgit }:

stdenv.mkDerivation rec
{
  name = "safepaste";
  src = fetchgit
  {
    url = "https://github.com/jeaye/safepaste.git";
    deepClone = true;
    rev = "feb8d45dea622adc22b8b19f88515c409a5bae58";
    sha256 = "13gb6dv72jn5bgw04bqi9cx77dqbqrr5ylx8qjhyb4l4p0x93bqy";
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
