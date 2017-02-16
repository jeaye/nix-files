{ stdenv, pkgs, fetchgit }:

stdenv.mkDerivation rec
{
  name = "wordy-word";
  src = fetchgit
  {
    url = "https://github.com/jeaye/wordy-word.git";
    deepClone = true;
    rev = "60e19f83030a0c020967b7327d6c20ed00ac31df";
    sha256 = "1rjkcc42giaf1809fxbbcmgk0g1xc6adkk17q3dx74hckkb135c0";
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
