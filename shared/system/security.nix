{ config, pkgs, ... }:

{
  # Prevent users from read the process info of other users
  security.hideProcessInformation = true;
}
