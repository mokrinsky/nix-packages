# This file describes your repository contents.
# It should return a set of nix derivations
# and optionally the special attributes `lib`, `modules` and `overlays`.
# It should NOT import <nixpkgs>. Instead, you should take pkgs as an argument.
# Having pkgs default to <nixpkgs> is fine though, and it lets you use short
# commands such as:
#     nix-build -A mypackage
{pkgs ? import <nixpkgs> {}}: {
  # The `lib`, `modules`, and `overlay` names are special
  # lib = import ./lib {inherit pkgs;}; # functions
  # overlays = import ./overlays; # nixpkgs overlays

  pidof = pkgs.callPackage ./pkgs/pidof {};
  squid = pkgs.callPackage ./pkgs/squid {};
  fzf = pkgs.callPackage ./pkgs/fzf {};
  ovirt-engine-sdk-python = pkgs.callPackage ./pkgs/ovirt-engine-sdk-python {};
  coreutils = pkgs.callPackage ./pkgs/coreutils {};
  wireguard-tools = pkgs.callPackage ./pkgs/wireguard-tools {};
}
