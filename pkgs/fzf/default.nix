{
  fzf,
  runtimeShell,
  installShellFiles,
  go,
}:
fzf.overrideAttrs (oldAttrs: rec {
  nativeBuildInputs = [installShellFiles go];

  postInstall = ''
    installManPage man/man1/fzf.1
    # Install shell integrations
    install -D shell/* -t $out/share/fzf/
    cat <<SCRIPT > $out/bin/fzf-share
    #!${runtimeShell}
    # Run this script to find the fzf shared folder where all the shell
    # integration scripts are living.
    echo $out/share/fzf
    SCRIPT
    chmod +x $out/bin/fzf-share
  '';
})
