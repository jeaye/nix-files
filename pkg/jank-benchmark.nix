{ stdenv, pkgs, fetchgit }:

stdenv.mkDerivation rec
{
  name = "jank-benchmark";
  src = fetchgit
  {
    url = "https://github.com/jeaye/jank-benchmark.git";
    deepClone = true;
    rev = "8786b1e788224263cc5f6ce8aab378ff6d911998";
    sha256 = "13gb6dv72jn5bgw04bqi9cx77dqbqrr5ylx8qjhyb4l4p0x93bqy";
  };
  buildInputs = [ pkgs.leiningen ];
  buildPhase =
  ''
    # For leiningen
    export HOME=$PWD

    ${pkgs.leiningen}/bin/lein uberjar
  '';
  installPhase =
  ''
    mkdir -p $out/{bin,share}
    install -m 0644 target/jank-benchmark.jar $out/bin/
  '';
}
