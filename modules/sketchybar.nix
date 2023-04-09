{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.services.sketchybar;
in {
  options.services.sketchybar = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to enable the sketchybar panel daemon.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.sketchybar;
      description = "This option specifies the sketchybar package to use.";
    };

    sketchybarConfig = mkOption {
      type = types.lines;
      default = "";
      example = ''
        #!/usr/bin/bash

        sketchybar --bar height=32 blur_radius=0 position=top sticky=on \
          padding_left=5 padding_right=5 display=main color=0xffffffff
      '';
      description = "Config to use for <filename>sketchybarrc</filename>.";
    };
  };

  config = mkIf cfg.enable {
    home.packages = [cfg.package];

    xdg.configFile."sketchybar/sketchybarrc".text = cfg.sketchybarConfig;

    launchd.agents.sketchybar = {
      enabled = true;
      config = {
        ProgramArguments = ["${lib.getExe cfg.package}"];
        KeepAlive = true;
        RunAtLoad = true;
        ProcessType = "Interactive";
        Nice = -20;
        EnvironmentVariables = {
          PATH = "${lib.makeBinPath [
            cfg.package
            config.home.profileDirectory
          ]}";
        };
      };
    };
  };
}
