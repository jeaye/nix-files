{ config, pkgs, lib, ... }:

{
  system.activationScripts =
  {
    jeaye-home =
    {
      deps = [];
      text =
      ''
        # TODO: Make a package for this instead
        home_source=/etc/nixos/workstation/user/jeaye/data/home
        for file_dir in $(find "$home_source" -mindepth 1 -maxdepth 1);
        do
          base=$(basename "$file_dir")
          ln -sf "$file_dir" "/etc/user/jeaye/$base"
        done

        # TODO: Vimrc package
      '';
    };
  };
}
