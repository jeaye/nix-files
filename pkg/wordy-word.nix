{ stdenv, pkgs, fetchgit }:

stdenv.mkDerivation rec
{
  name = "wordy-word";
  src = fetchgit
  {
    url = "https://github.com/jeaye/wordy-word.git";
    deepClone = true;
    rev = "070266bb8cb44c33fb147a01500951b833963cce";
    sha256 = "1kq8bbjbqyphv08bkc3jix8ha9cqsnj6gj9gvsmp3rkpkgh6rr3s";
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
