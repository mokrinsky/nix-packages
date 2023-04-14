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
    enable = mkEnableOption "Whether to enable the sketchybar panel daemon.";

    package = mkOption {
      type = types.package;
      default = pkgs.sketchybar;
      description = "This option specifies the sketchybar package to use.";
    };

    logFile = mkOption {
      type = types.str;
      default = "";
      example = "${config.xdg.cacheHome}/sketchybar.log";
      description = "Path where you want to write daemon logs.";
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

    extraPackages = mkOption {
      type = with types; listOf package;
      default = [];
      example = literalExpression "[ pkgs.shfmt ]";
      description = "Extra packages available to sketchybar.";
    };

    extraPath = mkOption {
      type = with types; listOf str;
      default = ["/bin" "/usr/bin" "/sbin" "/usr/sbin"];
      description = "List of binary folders to put into PATH variable.";
    };
  };

  config = mkIf cfg.enable {
    home.packages = [cfg.package];

    xdg.configFile."sketchybar/sketchybarrc".text = cfg.sketchybarConfig;

    launchd.agents.sketchybar = {
      enable = true;
      config = {
        ProgramArguments = ["${lib.getExe cfg.package}"];
        KeepAlive = true;
        RunAtLoad = true;
        ProcessType = "Interactive";
        StandardErrorPath = mkIf (cfg.logFile != "") "${cfg.logFile}";
        StandardOutPath = mkIf (cfg.logFile != "") "${cfg.logFile}";
        Nice = -20;
        EnvironmentVariables = {
          PATH = builtins.concatStringsSep ":" ([
              "${lib.makeBinPath [cfg.package]}"
              (optionalString (cfg.extraPackages != []) "${lib.makeBinPath cfg.extraPackages}")
            ]
            ++ cfg.extraPath);
        };
      };
    };
  };
}
