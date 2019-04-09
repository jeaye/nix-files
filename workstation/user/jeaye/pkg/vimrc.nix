{ stdenv, fetchgit }:

stdenv.mkDerivation rec
{
  name = "jeaye-vimrc";
  src = fetchgit
  {
    url = "https://github.com/jeaye/vimrc.git";
    deepClone = true;
    rev = "c718665";
    sha256 = "052hy2shkldqnkgr9vijadrwns5skgplf5027hrd5avp7vw65z42";
  };
  installPhase =
  ''
    mkdir -p $out
    cp -r $src/* $out/
  '';
}
