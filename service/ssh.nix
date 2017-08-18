{ config, pkgs, ... }:

{
  services.openssh =
  {
    enable = true;
    forwardX11 = false;
    permitRootLogin = "no";
    allowSFTP = false;
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
      AllowGroups ssh-user

      ### Recommended settings from both:
      # https://stribika.github.io/2015/01/04/secure-secure-shell.html
      # and
      # https://wiki.mozilla.org/Security/Guidelines/OpenSSH#Modern_.28OpenSSH_6.7.2B.29

      KexAlgorithms curve25519-sha256@libssh.org,diffie-hellman-group-exchange-sha256
      Ciphers chacha20-poly1305@openssh.com,aes256-gcm@openssh.com,aes128-gcm@openssh.com,aes256-ctr,aes192-ctr,aes128-ctr
      MACs hmac-sha2-512-etm@openssh.com,hmac-sha2-256-etm@openssh.com,hmac-ripemd160-etm@openssh.com,umac-128-etm@openssh.com,hmac-sha2-512,hmac-sha2-256,hmac-ripemd160,umac-128@openssh.com

      # NixOS enables ssh-dss, so this sets things back to the defaults.
      PubkeyAcceptedKeyTypes ecdsa-sha2-nistp256-cert-v01@openssh.com, ecdsa-sha2-nistp384-cert-v01@openssh.com, ecdsa-sha2-nistp521-cert-v01@openssh.com, ssh-ed25519-cert-v01@openssh.com, ssh-rsa-cert-v01@openssh.com, ecdsa-sha2-nistp256,ecdsa-sha2-nistp384,ecdsa-sha2-nistp521, ssh-ed25519,ssh-rsa

      # LogLevel VERBOSE logs user's key fingerprint on login.
      # Needed to have a clear audit track of which key was using to log in.
      LogLevel VERBOSE

      # Use kernel sandbox mechanisms where possible in unprivileged processes.
      UsePrivilegeSeparation sandbox
    '';
  };

  networking.firewall.allowedTCPPorts = [ 22 ];
}
