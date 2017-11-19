{ stdenv, fetchgit }:

stdenv.mkDerivation rec
{
  name = "jeaye-vimrc";
  src = fetchgit
  {
    url = "https://github.com/jeaye/vimrc.git";
    deepClone = true;
    rev = "48fc073c597358e840695d085d3362e6c187993b";
    sha256 = "0dp6hlz45mmnzz7a1jcv49gdicnsi6wb875vs8cazn5x9s9dk0zg";
  };
  installPhase =
  ''
    mkdir -p $out
    cp -r $src/* $out/
  '';
}
