{ stdenv, pkgs, fetchgit }:

stdenv.mkDerivation rec
{
  name = "safepaste";
  src = fetchgit
  {
    url = "https://github.com/jeaye/safepaste.git";
    deepClone = true;
    rev = "0593b68f1d0fb2b41ea14b026bcde4d662c1dbb4";
    sha256 = "1dry2gqmc507jgnp7y0llml9s9mmqzimk75rw8gmxqf79j0jwhnp";
  };
  buildInputs = [ pkgs.boot pkgs.nodejs ];
  buildPhase =
  ''
    # For leiningen
    export HOME=$PWD
    export LEIN_HOME=$HOME/.lein
    mkdir -p $LEIN_HOME
    echo "{:user {:local-repo \"$LEIN_HOME\"}}" > $LEIN_HOME/profiles.clj

    ./bin/package
  '';
  installPhase =
  ''
    mkdir -p $out/{bin,share}
    install -m 0644 target/safepaste-standalone.jar $out/bin/
    install -m 0755 tool/clean-expired $out/bin/
    install -m 0755 tool/encrypt $out/bin/
    install -m 0755 tool/ban $out/bin/
    install -m 0644 src/paste/about $out/share/
  '';
}
