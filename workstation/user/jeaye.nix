{ config, pkgs, ... }:

{
  users.users.jeaye =
  {
    isNormalUser = true;
    createHome = true;
    group = "users";
    home = "/etc/user/jeaye";
    extraGroups = [ "wheel" "ssh-user" ];
  };

  environment.systemPackages = with pkgs;
  [
    pinentry
    gnupg
  ];

  imports =
  [
    ./jeaye/home.nix
  ];
}
