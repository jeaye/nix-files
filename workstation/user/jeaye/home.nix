{ config, pkgs, lib, ... }:

let
  # TODO: Use readDir + map to get these automatically.
  dotfiles = [ "config" "i3status.conf" ];
  make-dotfile = file:
  {
    source = ./data/dotfiles + "/${file}";
    target = "user/jeaye/.${file}";
  };
in
{
  environment.etc = map make-dotfile dotfiles;
}
