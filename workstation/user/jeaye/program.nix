{ config, pkgs, lib, ... }:

let pkgsUnstable = import
  (
    fetchTarball https://github.com/NixOS/nixpkgs/archive/master.tar.gz
  )
{ };
in
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
      # Noice requires nvim >=0.11
      pkgsUnstable.neovim
      fzf
      xclip
      flameshot

      ## Browsing
      firefox
      chromium

      ## Calendar
      thunderbird

      ## Media
      clementine
      mpv
      pavucontrol
      transmission_4-gtk
      pkgsUnstable.qbittorrent
      # For querying the currently playing media (MPRIS).
      playerctl

      ## Chat
      pkgsUnstable.signal-desktop

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
      rlwrap
      leiningen
      tree
      clang
      # clangd
      clang-tools
      cmake
      ninja
      gnumake
      mdbook
      asciinema
      # p4merge
      p4v

      ## Art
      inkscape
      gimp
      blender
    ];
  };

  nixpkgs.overlays = [
  (self: super: {
    mpv = super.mpv.override {
      scripts = [ self.mpvScripts.mpris ];
    };
  })
];

  #nixpkgs.config.packageOverrides = self : rec {
  #  blender = self.blender.override {
  #    cudaSupport = true;
  #  };
  #};

  documentation.dev.enable = true;
}
