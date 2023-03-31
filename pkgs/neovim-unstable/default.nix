{
  neovim-unwrapped,
  pkgs,
}:
neovim-unwrapped.overrideAttrs (oldAttrs: rec {
  version = "0.9.0-dev";

  src = pkgs.fetchFromGitHub {
    owner = "neovim";
    repo = "neovim";
    rev = "5bf2f4b3c29fdab72044ddce74f06cb45fe9401c";
    hash = "sha256-Y3XAV9bEOLJgs+u9mwQowLASFoVJjpobC7CXCe05Mzk=";
  };

  patches = [
    # introduce a system-wide rplugin.vim in addition to the user one
    # necessary so that nix can handle `UpdateRemotePlugins` for the plugins
    # it installs. See https://github.com/neovim/neovim/issues/9413.
    ./system_rplugin_manifest.patch
  ];
})
