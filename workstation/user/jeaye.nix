{ config, pkgs, ... }:

{
  users.users.jeaye =
  {
    isNormalUser = true;
    home = "/etc/user/jeaye";
    extraGroups = [ "wheel"  "ssh-user" ];
  };

  environment.systemPackages = with pkgs;
  [
    pinentry
    gnupg
  ];
}
