{ stdenv, fetchFromGitHub, fetchpatch, pythonPackages }:

pythonPackages.buildPythonApplication rec
{
  pname = "simp_le-client";
  version = "0.3.0";
  name = "${pname}-${version}";

  src = pythonPackages.fetchPypi {
    inherit pname version;
    sha256 = "13nqfxlpw9y8r5p83cz5ms7i43vrarkrz2kfgnc9s6k1l2nbl6dm";
  };

  checkPhase = ''
    $out/bin/simp_le --test
  '';

  propagatedBuildInputs = with pythonPackages; [ acme setuptools_scm ];

  meta = with stdenv.lib; {
    homepage = "https://github.com/zenhack/simp_le";
    description = "Simple Let's Encrypt client";
    license = licenses.gpl3;
    maintainers = with maintainers; [ gebner nckx ];
    platforms = platforms.all;
  };
}
