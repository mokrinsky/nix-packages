{
  lib,
  stdenv,
  fetchurl,
  perl,
  openldap,
  db,
  cyrus_sasl,
  expat,
  libxml2,
  openssl,
  pkg-config,
  cppunit,
}:
stdenv.mkDerivation rec {
  pname = "squid";
  version = "5.7";

  src = fetchurl {
    url = "http://www.squid-cache.org/Versions/v5/${pname}-${version}.tar.xz";
    hash = "sha256-awdTqrpMnE79Mz5nEkyuz3rWzC04WB8Z0vAyH1t+zYE=";
  };

  nativeBuildInputs = [pkg-config];
  buildInputs = [
    perl
    openldap
    db
    cyrus_sasl
    expat
    libxml2
    openssl
  ];

  enableParallelBuilding = true;

  configureFlags = [
    "--disable-arch-native"
    "--disable-debug"
    "--disable-dependency-tracking"
    "--disable-eui"
    "--disable-strict-error-checking"
    "--enable-delay-pools"
    "--enable-disk-io=yes"
    "--enable-htcp"
    "--enable-ipv6"
    "--enable-pf-transparent"
    "--enable-removal-policies=yes"
    "--enable-ssl"
    "--enable-ssl-crtd"
    "--enable-storeio=yes"
    "--enable-x-accelerator-vary"
    "--with-included-ltdl"
    "--with-openssl"
  ];

  doCheck = true;
  nativeCheckInputs = [cppunit];
  preCheck = ''
    # tests attempt to copy around "/bin/true" to make some things
    # no-ops but this doesn't work if our "true" is a multi-call
    # binary, so make our own fake "true" which will work when used
    # this way
    echo "#!$SHELL" > fake-true
    chmod +x fake-true
    grep -rlF '/bin/true' test-suite/ | while read -r filename ; do
      substituteInPlace "$filename" \
        --replace "$(type -P true)" "$(realpath fake-true)" \
        --replace "/bin/true" "$(realpath fake-true)"
    done
  '';

  postInstall = ''
    mkdir -p $out/Library/LaunchDaemons
    cp ${./yumi.nix.squid.plist} $out/Library/LaunchDaemons/yumi.nix.squid.plist
    substituteInPlace $out/Library/LaunchDaemons/yumi.nix.squid.plist --subst-var out
  '';

  meta = with lib; {
    description = "A caching proxy for the Web supporting HTTP, HTTPS, FTP, and more";
    homepage = "http://www.squid-cache.org";
    license = licenses.gpl2Plus;
    platforms = platforms.darwin;
    # maintainers = with maintainers; [yumi];
    broken = stdenv.isLinux;
  };
}
