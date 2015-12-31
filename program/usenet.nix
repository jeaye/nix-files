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
      slrn = pkgs.slrn.override
      {
        configureFlags = "--with-ssl=${pkgs.openssl}";
        buildInputs = [ slang ncurses openssl ];
      };
    };
  };

  environment.etc."user/usenet/slrnrc".text =
    lib.readFile ./usenet/slrnrc;
  environment.etc."user/usenet/bashrc".text =
    lib.readFile ./usenet/bashrc;

  users.users.usenet =
  {
    isNormalUser = true;
    home = "/home/usenet";
    createHome = true;
  };

  # XXX: Setup ~/.secret/slrn passwords
  system.activationScripts =
  {
    usenet-home =
    {
      deps = [];
      text =
      ''
        PATH=${pkgs.su}/bin:$PATH
        su - usenet -c "ln -sf /etc/user/usenet/bashrc ~/.bashrc"
        su - usenet -c "ln -sf /etc/user/usenet/slrnrc ~/.slrnrc"
      '';
    };
  };
}
