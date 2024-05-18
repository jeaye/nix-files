{ config, pkgs, ... }:

{
  security.sudo =
  {
    enable = true;
    wheelNeedsPassword = true;
  };

  # Allow useradd/groupadd imperatively.
  users.mutableUsers = true;
}
