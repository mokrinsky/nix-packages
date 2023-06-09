{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.programs.java;
in {
  options = {
    programs.java = {
      extraPackages = mkOption {
        type = types.listOf types.package;
        default = [];
        description = "List of extra JDK packages in case you need several versions installed";
      };

      installMaven = mkOption {
        type = types.bool;
        default = false;
        description = "Whether install <literal>pkgs.maven</literal> or not.";
      };
    };
  };

  config = let
    packageList = [cfg.package] ++ cfg.extraPackages;
    getCommand = with builtins;
      pkg:
        if pkgs.stdenv.isDarwin
        then ''
          /usr/bin/sudo rm -rf /Library/Java/JavaVirtualMachines/hm-jdk-${head (splitVersion pkg.version)}* || :
          /usr/bin/sudo ln -s ${pkg} /Library/Java/JavaVirtualMachines/hm-jdk-${pkg.version}
        ''
        else ''
          /usr/bin/sudo rm -rf /usr/lib/jvm/hm-jdk-${head (splitVersion pkg.version)}* || :
          /usr/bin/sudo ln -s ${pkg} /usr/lib/jvm/hm-jdk-${pkg.version}
        '';
  in
    mkIf cfg.enable {
      home.packages =
        optionals cfg.installMaven [pkgs.maven];

      home.activation.linkJava = hm.dag.entryAfter ["linkGeneration"] ''
        linkJava() {
          ${builtins.concatStringsSep "\n" (map getCommand packageList)}
        }

        linkJava
      '';
    };
}
