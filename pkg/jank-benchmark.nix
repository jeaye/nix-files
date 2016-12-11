{ stdenv, pkgs, fetchgit }:

stdenv.mkDerivation rec
{
  name = "jank-benchmark";
  src = fetchgit
  {
    url = "https://github.com/jeaye/jank-benchmark.git";
    deepClone = true;
    rev = "01f3a47d824b13224c2bdc182463f5f0ac0d5346";
    sha256 = "1g36f1pdfdjw0gj96y3n9nszqh5ds20ccsf1znw6199s1awnawws";
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
    install -m 0644 target/jank-benchmark.jar $out/bin/
  '';
}
