{
  neovim-unwrapped,
  runtimeShell,
  installShellFiles,
  fetchFromGithub,
}:
neovim-unwrapped.overrideAttrs (oldAttrs: rec {
  version = "0.9.0-dev";

  src = fetchFromGitHub {
    owner = "neovim";
    repo = "neovim";
    rev = "5bf2f4b3c29fdab72044ddce74f06cb45fe9401c";
    hash = "sha256-Y3XAV9bEOLJgs+u9mwQowLASFoVJjpobC7CXCe05Mzk=";
  };
})
