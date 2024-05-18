{ config, pkgs, lib, ... }:

{
  users.users.jeaye =
  {
    packages = with pkgs;
    [
      ## Security
      pinentry
      gnupg
      keepassxc

      ## Editing
      neovim
      fzf
      xclip
      flameshot

      ## Browsing
      firefox

      ## Calendar
      thunderbird

      ## Media
      clementine
      mpv
      pavucontrol
      qbittorrent
      # For querying the currently playing media (MPRIS).
      playerctl

      ## Chat
      signal-desktop

      ## Dictionary
      dict
      dictdDBs.wordnet

      ## Development
      man-pages
      man-pages-posix
      # For debugging nix builds with breakpointHook
      cntr
      distrobox
      # For distrobox X sharing, needed for clipboard sharing
      xorg.xhost
      pinentry-curses
      clojure
      clojure-lsp
      leiningen
      tree
      clang
      cmake
      ninja
      gnumake

      ## Art
      inkscape
      gimp
    ];
  };

  nixpkgs.overlays = [
  (self: super: {
    mpv = super.mpv.override {
      scripts = [ self.mpvScripts.mpris ];
    };
  })
];

  documentation.dev.enable = true;
}
