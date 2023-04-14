{lib, ...}: let
  inherit (import ../lib {inherit lib;}) importModules;
in {
  imports = importModules ./.;
}
