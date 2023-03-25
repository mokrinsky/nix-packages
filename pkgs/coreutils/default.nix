{
  coreutils,
  stdenv,
  lib,
  singleBinary ? "symlinks",
  minimal ? true,
  withOpenssl ? !minimal,
  withPrefix ? false,
}: let
  inherit (lib) isString optional optionals optionalString;
  isCross = stdenv.hostPlatform != stdenv.buildPlatform;
in
  coreutils.overrideAttrs (oldAttrs: rec {
    configureFlags =
      ["--with-packager=https://nixos.org"]
      ++ optional (singleBinary != false)
      ("--enable-single-binary" + optionalString (isString singleBinary) "=${singleBinary}")
      ++ optional withOpenssl "--with-openssl"
      ++ optional stdenv.hostPlatform.isSunOS "ac_cv_func_inotify_init=no"
      ++ optional withPrefix "--program-prefix=g"
      ++ optional stdenv.isDarwin "--disable-nls"
      ++ optionals (isCross && stdenv.hostPlatform.libc == "glibc") [
        "fu_cv_sys_stat_statfs2_bsize=yes"
      ]
      ++ optional stdenv.hostPlatform.isLinux "gl_cv_have_proc_uptime=yes"
      ++ optional stdenv.isDarwin "--enable-no-install-program=uptime";
  })
