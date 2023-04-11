{
  description = "yumi's nixpkgs overlay";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    pre-commit-hooks = {
      url = "github:cachix/pre-commit-hooks.nix";
      inputs = {
        flake-utils.follows = "flake-utils";
        nixpkgs.follows = "nixpkgs";
      };
    };
  };
  outputs = {
    self,
    nixpkgs,
    flake-utils,
    pre-commit-hooks,
    ...
  }:
    {
      homeManagerModules.default = import ./modules;
    }
    // (flake-utils.lib.eachDefaultSystem (
      system: let
        pkgs = import nixpkgs {
          inherit system;
        };
      in {
        packages = import ./default.nix {
          inherit pkgs;
        };

        devShells.default = pkgs.mkShell {
          inherit (self.checks.${system}.pre-commit-check) shellHook;
          name = "devShell";
          packages = with pkgs; [
            commitizen
          ];
        };

        checks = {
          pre-commit-check = pre-commit-hooks.lib.${system}.run {
            src = ./.;
            hooks = {
              alejandra.enable = true;
              deadnix.enable = true;
              # statix.enable = true;
            };
            settings.deadnix = {
              noLambdaPatternNames = true;
              noLambdaArg = true;
            };
          };
        };
      }
    ));
}
