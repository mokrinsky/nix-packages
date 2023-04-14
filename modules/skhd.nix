{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.services.skhd;
  configFile = pkgs.writeText "skhdrc" cfg.skhdConfig;
in {
  options.services.skhd = {
    enable = mkEnableOption "Whether to enable the skhd hotkey daemon.";

    logFile = mkOption {
      type = types.str;
      default = "";
      example = "${config.xdg.cacheHome}/skhd.log";
      description = "Path where you want to write daemon logs.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.skhd;
      description = "This option specifies the skhd package to use.";
    };

    skhdConfig = mkOption {
      type = types.lines;
      default = "";
      example = "alt + shift - r   :   chunkc quit";
      description = "Config to use for <filename>skhdrc</filename>.";
    };
  };

  config = mkIf cfg.enable {
    home.packages = [cfg.package];

    launchd.agents.skhd = {
      enable = true;
      config = {
        ProgramArguments =
          ["${getExe cfg.package}"]
          ++ optionals (cfg.skhdConfig != "") ["-c" "${configFile}"];
        KeepAlive = true;
        ProcessType = "Interactive";
        StandardErrorPath = mkIf (cfg.logFile != "") "${cfg.logFile}";
        StandardOutPath = mkIf (cfg.logFile != "") "${cfg.logFile}";
        EnvironmentVariables = {
          PATH = "${lib.makeBinPath [
            cfg.package
            config.home.profileDirectory
          ]}:/bin:/usr/bin";
        };
      };
    };
  };
}
