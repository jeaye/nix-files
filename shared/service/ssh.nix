{ config, pkgs, lib, ... }:

{
  services.openssh =
  {
    enable = true;
    allowSFTP = lib.mkDefault false;
    settings =
    {
      X11Forwarding = false;
      PermitRootLogin = "no";
    };
    hostKeys =
    [
      { type = "ed25519"; path = "/etc/ssh/ssh_host_ed25519_key"; }
      { type = "rsa"; bits = 4096; path = "/etc/ssh/ssh_host_rsa_key"; }
    ];
    extraConfig =
    ''
      PermitEmptyPasswords no

      # Avoid DNS lookups.
      UseDNS no

      # Throttle to a reasonable amount for a small server.
      MaxStartups 5
      MaxSessions 5
      MaxAuthTries 5

      # Don't allow just anyone to use SSH.
      AllowGroups ssh

      # LogLevel VERBOSE logs user's key fingerprint on login.
      # Needed to have a clear audit track of which key was used to log in.
      LogLevel VERBOSE

      # Use kernel sandbox mechanisms where possible in unprivileged processes.
      UsePrivilegeSeparation sandbox
    '';
  };

  networking.firewall.allowedTCPPorts = lib.mkDefault [ 22 ];
}
