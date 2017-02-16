{ stdenv, pkgs, fetchgit }:

stdenv.mkDerivation rec
{
  name = "wordy-word";
  src = fetchgit
  {
    url = "https://github.com/jeaye/wordy-word.git";
    deepClone = true;
    rev = "500ab6e3712bcd802b65ccb8bc6650f556b4bb91";
    sha256 = "0d3xa4953860s79nmaz452sc7isfzj33qynsbk3damggdhzq9g8x";
  };
  buildInputs = [ pkgs.leiningen pkgs.wget ];
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
    install -m 0644 target/uberjar/wordy-word-0.1.0-SNAPSHOT-standalone.jar $out/bin/wordy-word.jar
    install build-word-lists $out/bin/
  '';
}
