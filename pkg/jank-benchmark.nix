{ stdenv, pkgs, fetchgit }:

stdenv.mkDerivation rec
{
  name = "jank-benchmark";
  src = fetchgit
  {
    url = "https://github.com/jeaye/jank-benchmark.git";
    deepClone = true;
    rev = "aa651f575b74db314f0b78cfc2face0b0b8d8de1";
    sha256 = "07d7x293zv4f5frx7gh010g4ldj3y8ak6zvqnc0jbx8gpzvz6635";
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
