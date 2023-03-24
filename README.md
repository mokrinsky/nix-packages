# nix-packages

**My personal [NUR](https://github.com/nix-community/NUR) repository**

## Cachix

I push my build results to [Cachix](https://cachix.org).
In case you for some reason use my NUR, feel free to add my cachix as well:
```nix
{
    nixConfig.trusted-public-keys = [
        "mokrinsky.cachix.org-1:PkpcFI8pgsaQpOyoYyMdiA6sXJol1lhfsv6mCiH9jTY="
    ];
    nixConfig.trusted-substituters = [
        "https://mokrinsky.cachix.org"
    ];
}
```

![Build and populate cache](https://github.com/mokrinsky/nix-packages/workflows/Build%20and%20populate%20cache/badge.svg)

