# nix-packages

**My personal [NUR](https://github.com/nix-community/NUR) repository**

![Build and populate cache](https://github.com/mokrinsky/nix-packages/workflows/Build%20and%20populate%20cache/badge.svg)

## Content

This repo contains several packages I need. They're mostly replacements of some packages in main `nixpkgs` tree.

| package | comment |
|:-|:-|
| coreutils | For some reason `uptime` tool from main tree shows me a time since 01.01.1970. This one disables `uptime` command. |
| fzf | Main tree version of `fzf` installs bindings for `fish` that break my configuration. This one doesn't install fish bindings. |
| pidof | MacOS doesn't have `pidof` tool which I like. |
| squid | For some reason `squid` from the main tree is marked as uncompatible with darwin. |
| ovirt-engine-sdk-python | I'm ansible dev and I rule my oVirt clusters with ansible. For some unknown reason this package is absent from the main tree. |

I also have `home-manager` modules for `yabai`, `skhd`, `sketchybar` and `wireguard`. `yabai`, `skhd` and `wireguard` modules exist in `nix-darwin` tree but I'd like them to be installed with `home-manager`. `sketchybar` doesn't have its own module at all.

## Cachix

I push my build results to [Cachix](https://cachix.org).
In case you for some reason use my NUR, feel free to add my cachix as well:
```nix
{
    nixConfig = {
        trusted-public-keys = [
            "mokrinsky.cachix.org-1:PkpcFI8pgsaQpOyoYyMdiA6sXJol1lhfsv6mCiH9jTY="
        ];
        trusted-substituters = [
            "https://mokrinsky.cachix.org"
        ];
    };
}
```

