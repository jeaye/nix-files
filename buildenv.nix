with import <nixpkgs>{};

stdenv.mkDerivation {
  name = "buildenv";
  buildInputs = [ cmake lua boost zlib ncurses gcc5 ];
}
