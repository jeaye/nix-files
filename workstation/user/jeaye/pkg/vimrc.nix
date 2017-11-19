{ stdenv, fetchgit }:

stdenv.mkDerivation rec
{
  name = "jeaye-vimrc";
  src = fetchgit
  {
    url = "https://github.com/jeaye/vimrc.git";
    deepClone = true;
    rev = "19a28f08483b69a23f1eb976a7a96ea301e311a0";
    sha256 = "0wzdzhp9q40dixfpkawngga7bylzspnjgiccrl5fa8yh36v0hp72";
  };
  installPhase =
  ''
    mkdir -p $out
    cp -r $src/* $out/
  '';
}
