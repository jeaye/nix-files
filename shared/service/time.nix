{ config, pkgs, ... }:

{
  time.timeZone = "America/Los_Angeles";
  services.ntp.enable = false;
}
