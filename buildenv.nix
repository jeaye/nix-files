with import <nixpkgs>{};

stdenv.mkDerivation {
  name = "buildenv";
  buildInputs = [ cmake lua5_1 boost zlib ncurses gcc5 ];
}
