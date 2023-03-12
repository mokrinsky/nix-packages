{
  lib,
  python3,
  fetchPypi,
  libxml2Python,
}:
python3.pkgs.buildPythonPackage rec {
  pname = "ovirt-engine-sdk-python";
  version = "4.6.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "25565884eebd7b77cb97d9553c7bffb56f93fa1357e4494385d87c33042973e6";
  };

  sourceRoot = ".";

  doCheck = false;

  propagatedBuildInputs = [
    python3.pkgs.pycurl
    python3.pkgs.six
    libxml2Python
  ];

  preConfigure = ''
    substituteInPlace setup.py --replace "/usr/include/libxml2" "${lib.getDev libxml2Python}/include/libxml2"
  '';

  meta = with lib; {
    homepage = "https://github.com/oVirt/ovirt-engine-sdk";
    description = "The oVirt Python-SDK is a software development kit for the oVirt engine API";
    license = licenses.asl20;
  };
}
