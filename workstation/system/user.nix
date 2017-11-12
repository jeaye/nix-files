{ config, pkgs, ... }:

{
  security.sudo =
  {
    enable = true;
    wheelNeedsPassword = true;
  };

  # Disallow useradd/groupadd imperatively.
  users.mutableUsers = false;
}
