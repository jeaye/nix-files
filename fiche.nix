{ config, pkgs, fetchFromGitHub, ... }:

{
  environment.etc = [
    {
      source = pkgs.fetchFromGitHub {
        owner = "solusipse";
        repo = "fiche";
        rev = "8f3e23d3de66aa894f78417523cb6aeb208b6d60";
        sha256 = "1fhdp90k4dv5vps3fzip0g64haf8j6vp2mpk17w89qg7kyb1bwi6";
      };
      target = "fiche";
    }
  ];
}
