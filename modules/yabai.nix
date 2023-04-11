{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.services.yabai;

  toYabaiConfig = opts:
    concatStringsSep "\n" (mapAttrsToList
      (p: v: "yabai -m config ${p} ${toString v}")
      opts);

  configFile =
    mkIf (cfg.config != {} || cfg.extraConfig != "")
    "${pkgs.writeScript "yabairc" (
      (
        if (cfg.config != {})
        then "${toYabaiConfig cfg.config}"
        else ""
      )
      + optionalString (cfg.extraConfig != "") ("\n" + cfg.extraConfig + "\n")
    )}";

  saScript = mkIf cfg.enableScriptingAddition "${
    pkgs.writeScript "yabai-sa" ''
      if [ ! $(sudo ${cfg.package}/bin/yabai --check-sa) ]; then
        sudo ${cfg.package}/bin/yabai --install-sa
      fi

      sudo ${cfg.package}/bin/yabai --load-sa
    ''
  }";
in {
  options.services.yabai = with types; {
    enable = mkOption {
      type = bool;
      default = false;
      description = "Whether to enable the yabai window manager.";
    };

    package = mkOption {
      type = path;
      default = pkgs.yabai;
      description = "The yabai package to use.";
    };

    logFile = mkOption {
      type = types.str;
      default = "";
      example = "${config.xdg.cacheHome}/yabai.log";
      description = "Path where you want to write daemon logs.";
    };

    enableScriptingAddition = mkOption {
      type = bool;
      default = false;
      description = ''
        Whether to enable yabai's scripting-addition.
        SIP must be disabled for this to work.
      '';
    };

    config = mkOption {
      type = attrs;
      default = {};
      example = literalExpression ''
        {
          focus_follows_mouse = "autoraise";
          mouse_follows_focus = "off";
          window_placement    = "second_child";
          window_opacity      = "off";
          top_padding         = 36;
          bottom_padding      = 10;
          left_padding        = 10;
          right_padding       = 10;
          window_gap          = 10;
        }
      '';
      description = ''
        Key/Value pairs to pass to yabai's 'config' domain, via the configuration file.
      '';
    };

    extraConfig = mkOption {
      type = str;
      default = "";
      example = literalExpression ''
        yabai -m rule --add app='System Preferences' manage=off
      '';
      description = "Extra arbitrary configuration to append to the configuration file";
    };
  };

  config = mkMerge [
    (mkIf cfg.enable {
      home.packages = [cfg.package];

      launchd.agents.yabai = {
        enable = true;
        config = {
          ProgramArguments =
            ["${cfg.package}/bin/yabai"]
            ++ optionals (cfg.config != {} || cfg.extraConfig != "") ["-c" configFile];
          KeepAlive = true;
          RunAtLoad = true;
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
    })

    (mkIf cfg.enableScriptingAddition {
      launchd.agents.yabai-sa = {
        enable = true;
        config = {
          ProgramArguments = [saScript];
          RunAtLoad = true;
          KeepAlive.SuccessfulExit = false;
        };
      };
    })
  ];
}
