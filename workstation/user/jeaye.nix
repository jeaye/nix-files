{ config, pkgs, ... }:

{
  users.users.jeaye =
  {
    isNormalUser = true;
    createHome = true;
    group = "users";
    home = "/etc/user/jeaye";
    extraGroups = [ "wheel" "ssh" "proc" "docker" ];
  };

  imports =
  [
    ./jeaye/home.nix
    ./jeaye/program.nix
  ];
}
