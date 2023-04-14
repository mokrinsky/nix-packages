{lib, ...}: {
  importModules = dir: let
    inherit (builtins) map;

    modules = let
      inherit (builtins) attrNames readDir;

      dirs = let
        inherit (lib) filterAttrs;
        use = n: v: lib.hasSuffix ".nix" n && n != "default.nix" && v == "regular";
      in
        filterAttrs use (readDir dir);
    in
      attrNames dirs;
  in
    map (module: "${dir}/${module}") modules;
}
