{ config, pkgs, lib, ... }:

let
  # TODO: Use readDir + map to get these automatically.
  dotfiles =
  [
    "bash_profile" "bashrc" "bashrc-alias" "bashrc-less" "bashrc-prompt"
    "config/i3"
    "i3status.conf"
    "gitconfig"
    "gitignore"
    "xinitrc" "Xresources"
    "lein/profiles.clj"
    "mpv/mpv.conf"
    "tmux.conf"
    "bin"
  ];
  make-dotfile = file:
  {
    source = ./data/dotfiles + "/${file}";
    target = "user/jeaye/.${file}";
  };
in
{
  nixpkgs.config.packageOverrides = pkgs:
  {
    jeaye-vimrc = pkgs.callPackage ./pkg/vimrc.nix { };
  };

  # TODO: Neovim links
  #environment.etc =
  #[
  #  ## Vim
  #  {
  #    source = pkgs.jeaye-vimrc + "/layer";
  #    target = "user/jeaye/.vim/layer";
  #  }
  #  {
  #    source = pkgs.jeaye-vimrc + "/build";
  #    target = "user/jeaye/.vim/build";
  #  }
  #  {
  #    source = pkgs.jeaye-vimrc + "/vimrc";
  #    target = "user/jeaye/.vimrc";
  #  }
  #  ## X
  #  {
  #    source = ./data/dotfiles/xinitrc;
  #    target = "user/jeaye/.xsession";
  #  }
  #] ++ (map make-dotfile dotfiles);

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

    # More fudging to account for environment.etc creations.
    jeaye-dotfiles =
    {
      deps = [];
      text =
      ''
        dotfile_dirs=$(echo /etc/user/jeaye/.{config,lein})
        mkdir -p $dotfile_dirs
        chown -R jeaye:users $dotfile_dirs
      '';
    };
  };
}
