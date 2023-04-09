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
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to enable the skhd hotkey daemon.";
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
      config.ProgramArguments =
        ["${cfg.package}/bin/skhd"]
        ++ optionals (cfg.skhdConfig != "") ["-c" configFile];
      config.KeepAlive = true;
      config.ProcessType = "Interactive";
      config.EnvironmentVariables = {
        PATH = "${lib.makeBinPath [
          cfg.package
          config.home.profileDirectory
        ]}";
      };
    };
  };
}
