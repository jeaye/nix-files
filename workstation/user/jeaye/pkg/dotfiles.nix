{ stdenv, pkgs }:

stdenv.mkDerivation rec
{
  name = "jeaye-dotfiles";
  src = ../data/dotfiles;
  targets = [ ".config" ".i3status.conf" ];
  installPhase =
  ''
    mkdir -p $out/etc/user/jeaye
    for target in $targets;
    do
      cp -rv $src/$target $out/
    done
  '';
}
