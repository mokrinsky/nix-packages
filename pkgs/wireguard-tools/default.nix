{
  wireguard-tools,
  runtimeShell,
}:
wireguard-tools.overrideAttrs (_oldAttrs: rec {
  postInstall = ''
    sed -i 's/CONFIG_SEARCH_PATHS=.*/CONFIG_SEARCH_PATHS=\( \/etc\/wireguard \/usr\/local\/etc\/wireguard ~\/.config\/wireguard \)/g' $out/bin/wg-quick
  '';
})
