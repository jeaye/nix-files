{ config, pkgs, ... }:

{
  system.activationScripts =
  {
    homes =
    {
      deps = [];
      text = (builtins.foldl'
      (us: u:
      ''
        ${us}
        ln -sf /etc/user/dotfiles/bash_profile /etc/user/${u.name}/.bash_profile
        ln -sf /etc/user/dotfiles/bashrc /etc/user/${u.name}/.bashrc
        ln -sf /etc/user/dotfiles/dir_colors /etc/user/${u.name}/.dir_colors
        ln -sf /etc/user/dotfiles/gitconfig /etc/user/${u.name}/.gitconfig
        ln -sf /etc/user/dotfiles/gitignore /etc/user/${u.name}/.gitignore
        ln -sf /etc/user/dotfiles/tmux.conf /etc/user/${u.name}/.tmux.conf
        ln -sf /etc/user/dotfiles/elinks /etc/user/${u.name}/.elinks
        chown -R ${u.name}:users /etc/user/${u.name}
      '')
      ""
      (builtins.filter (u: u.isNormalUser)
             (map (key: builtins.getAttr key config.users.users)
                  (builtins.attrNames config.users.users))));
    };
    root-home =
    {
      deps = [];
      text =
      ''
        ln -sf /etc/user/dotfiles/bash_profile /root/.bash_profile
        ln -sf /etc/user/dotfiles/bashrc /root/.bashrc
        ln -sf /etc/user/dotfiles/dir_colors /root/.dir_colors
        ln -sf /etc/user/dotfiles/tmux.conf /root/.tmux.conf
        ln -sf /etc/user/dotfiles/tmux-nixos.conf /root/.tmux-nixos.conf
      '';
    };
  };

  # Allow useradd/groupadd imperatively
  users.mutableUsers = true;
}
