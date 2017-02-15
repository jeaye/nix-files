{ stdenv, pkgs, fetchgit }:

stdenv.mkDerivation rec
{
  name = "wordy-word";
  src = fetchgit
  {
    url = "https://github.com/jeaye/wordy-word.git";
    deepClone = true;
    rev = "96aa9799a44efc8b427efa4eca6662be1fde70b8";
    sha256 = "0llsdkk4jx4a7hk0gl3nq953phwl3598dhalkmlipi8zv7w9iz82";
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
    install -m 0644 target/uberjar/wordy-word-0.1.0-SNAPSHOT-standalone.jar $out/bin/wordy-word.jar
  '';
}
