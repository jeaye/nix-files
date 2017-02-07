{ stdenv, pkgs, fetchgit }:

stdenv.mkDerivation rec
{
  name = "padwatch";
  src = fetchgit
  {
    url = "https://github.com/jeaye/padwatch.git";
    deepClone = true;
    rev = "e3503f8ce7daced9c6bacc45cd074cb41d5816a3";
    sha256 = "1pakv60q1rb1ymcv79csgrs32z0vgxw9zq5xym49hz6ycgg1hbz1";
  };
  buildInputs = [ pkgs.leiningen ];
  buildPhase =
  ''
    # For leiningen
    export HOME=$PWD
    export LEIN_HOME=$HOME/.lein
    mkdir -p $LEIN_HOME
    echo "{:user {:local-repo \"$LEIN_HOME\"}}" > $LEIN_HOME/profiles.clj

    ${pkgs.leiningen}/bin/lein uberjar
  '';
  installPhase =
  ''
    mkdir -p $out/{bin,share}
    install -m 0644 target/uberjar/padwatch-0.1.0-SNAPSHOT-standalone.jar $out/bin/padwatch.jar
  '';
}
