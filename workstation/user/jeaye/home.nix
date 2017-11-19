{ config, pkgs, lib, ... }:

let
  # TODO: Use readDir + map to get these automatically.
  dotfiles = [ "config" "i3status.conf" "gitconfig" ];
  make-dotfile = file:
  {
    source = ./data/dotfiles + "/${file}";
    target = "user/jeaye/.${file}";
  };
in
{
  nixpkgs.config =
  {
    packageOverrides = pkgs: rec
    {
      jeaye-vimrc = pkgs.callPackage ./pkg/vimrc.nix { };
    };
  };

  environment.etc =
  [
    {
      source = pkgs.jeaye-vimrc + "/layer";
      target = "user/jeaye/.vim/layer";
    }
    {
      source = pkgs.jeaye-vimrc + "/vimrc";
      target = "user/jeaye/.vimrc";
    }
  ] ++ map make-dotfile dotfiles;

  system.activationScripts =
  {
    # The permissions of ~/.vim need to be fudged, since it was made by Nix.
    jeaye-vimrc =
    {
      deps = [];
      text =
      ''
        vim_dirs=$(echo /etc/user/jeaye/.vim/{autoload,plugged})
        mkdir -p $vim_dirs
        chown -R jeaye:users $vim_dirs
      '';
    };
  };
}
