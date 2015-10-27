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
    leiningen
  ];
}
