{ config, pkgs, ... }:

{
  users.users.jeaye =
  {
    isNormalUser = true;
    createHome = true;
    group = "users";
    home = "/home/jeaye";
    extraGroups = [ "wheel" "networkmanager" "audio" "ssh" "proc" "docker" ];
  };

  imports =
  [
    #./jeaye/home.nix
    ./jeaye/program.nix
    ./jeaye/gaming.nix
    ./jeaye/desktop.nix
  ];
}
