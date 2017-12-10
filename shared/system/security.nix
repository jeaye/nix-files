{ config, pkgs, ... }:

{
  # Prevent users from read the process info of other users
  # TODO: Allow a group id to bypass this
  security.hideProcessInformation = true;
}
