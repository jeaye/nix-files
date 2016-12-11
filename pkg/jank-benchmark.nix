{ stdenv, pkgs, fetchgit }:

stdenv.mkDerivation rec
{
  name = "jank-benchmark";
  src = fetchgit
  {
    url = "https://github.com/jeaye/jank-benchmark.git";
    deepClone = true;
    rev = "8786b1e788224263cc5f6ce8aab378ff6d911998";
    sha256 = "1g36f1pdfdjw0gj96y3n9nszqh5ds20ccsf1znw6199s1awnawws";
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
