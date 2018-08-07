{ config, pkgs, ... }:

{
  users.users.okletsplay =
  {
    isNormalUser = false;
    createHome = false;
  };
}
