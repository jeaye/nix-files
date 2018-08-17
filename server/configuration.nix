{ config, pkgs, ... }:

# TODO: Add automatic blacklist lookup
# http://www.blacklistalert.org/
# https://mxtoolbox.com/SuperTool.aspx?action=blacklist%3a192.241.218.198&run=toolpage
# http://mail-blacklist-checker.online-domain-tools.com/

{
  imports =
  [
    ../hardware-configuration.nix # Auto-generated by nixos
    ../nixos-in-place.nix # Auto-generated by nixos-in-place

    ## Base system
    ./base.nix

    ## Global programs
    ./program/admin.nix

    ## Users
    ./system/user.nix

    ./user/irc.nix
    ./user/git.nix
    ./user/jeaye.nix
    ./user/fu-er.nix
    ./user/okletsplay.nix

    ## Services
    ./service/acme.nix
    ./service/httpd.nix
    ./service/domain-parking.nix
    ./service/postfix.nix
    ./service/dovecot.nix
    ./service/opendkim.nix
    ./service/spamassassin.nix
    ./service/safepaste.nix
    ./service/jank-benchmark.nix
    ./service/fail2ban.nix
    ./service/radicale.nix
    ./service/gpg.nix
    ./service/jank-license.nix
    ./service/upload.jeaye.com-tmp.nix
    ./service/wordy-word.nix
    ./service/rainloop.nix
    ./service/taskserver.nix

    #./container/nextcloud.nix
  ];

  networking.hostName = "nixums";
  system.stateVersion = "18.03";
}
