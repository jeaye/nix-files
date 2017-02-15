{ stdenv, pkgs, fetchgit }:

stdenv.mkDerivation rec
{
  name = "wordy-word";
  src = fetchgit
  {
    url = "https://github.com/jeaye/wordy-word.git";
    deepClone = true;
    rev = "4a5893e3b1a9f1caf9679e0881c34a5e1de66dfa";
    sha256 = "0vsqdnisfh3s771wmyzal7x2ifnh8gp0f17ngzgma3niymf0cb5z";
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

    ./build-word-lists
  '';
  installPhase =
  ''
    mkdir -p $out/{bin,share}
    install -m 0644 target/uberjar/wordy-word-0.1.0-SNAPSHOT-standalone.jar $out/bin/wordy-word.jar
    install -m 0644 unapproved-{adjectives,nouns} $out/
  '';
}
