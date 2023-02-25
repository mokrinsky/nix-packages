{
  stdenv,
  fetchurl,
  lib,
}:
stdenv.mkDerivation rec {
  name = "pidof";
  version = "0.1.4";

  src = fetchurl {
    url = "http://www.nightproductions.net/downloads/pidof_source.tar.gz";
    sha256 = "2a2cd618c7b9130e1a1d9be0210e786b85cbc9849c9b6f0cad9cbde31541e1b8";
  };

  buildPhase = ''
    clang -O3 -w pidof.c -o pidof
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/{bin,share/man/man1}
    install -s -m 755 pidof $out/bin
    install -m 644 pidof.1 $out/share/man/man1

    runHook postInstall
  '';
  # makeFlags = [ "CC=${stdenv.cc.targetPrefix}clang CFLAGS=-w DESTDIR=$(out)" ];

  meta = with lib; {
    description = "Display the PID number for a given process name";
    homepage = "http://www.nightproductions.net/cli.htm";
    platforms = platforms.darwin;
    # maintainers = with mainteiners; [yumi];
  };
}
