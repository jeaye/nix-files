{ config, pkgs, lib, ... }:

{
  environment.systemPackages = with pkgs;
  [
    slrn
  ];

  nixpkgs.config =
  {
    packageOverrides = pkgs: rec
    {
      slrn = pkgs.slrn.overrideDerivation (oldAttrs :
      {
        configureFlags = "--with-slang=${pkgs.slang} --with-ssl=${pkgs.openssl}";
        buildInputs = [ pkgs.slang pkgs.ncurses pkgs.openssl ];
      });
    };
  };

  environment.etc."user/usenet/slrnrc".text =
    lib.readFile ./usenet/slrnrc;
  environment.etc."user/usenet/bashrc".text =
    lib.readFile ./usenet/bashrc;

  # XXX: Setup ~/.secret/slrn passwords
  users.users.usenet =
  {
    isNormalUser = true;
    home = "/etc/user/usenet";
    createHome = true;
  };
}
