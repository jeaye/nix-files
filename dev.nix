{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    git
    gcc5
    llvm
    clang
    gnumake
    automake
    cmake
    lua
    python2
    python3
    leiningen
  ];
}
