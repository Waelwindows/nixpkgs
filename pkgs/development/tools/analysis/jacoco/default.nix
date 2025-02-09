{ lib
, stdenv
, fetchzip
, makeWrapper
, jre
}:

stdenv.mkDerivation rec {
  pname = "jacoco";
  version = "0.8.9";

  src = fetchzip {
    url = "https://search.maven.org/remotecontent?filepath=org/jacoco/jacoco/${version}/jacoco-${version}.zip";
    stripRoot = false;
    sha256 = "sha256-gxe3HoOAj4u6k7hBDe6r9uPj4xSt1wFNPVzhM9YAEMI=";
  };

  outputs = [ "out" "doc" ];

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall

    mkdir -p $doc/share/doc $out/bin

    cp -r doc $doc/share/doc/jacoco
    install -Dm444 lib/* -t $out/share/java

    makeWrapper ${jre}/bin/java $out/bin/jacoco \
      --add-flags "-jar $out/share/java/jacococli.jar"

    runHook postInstall
  '';

  meta = with lib; {
    description = "A free code coverage library for Java";
    homepage = "https://www.jacoco.org/jacoco";
    changelog = "https://www.jacoco.org/jacoco/trunk/doc/changes.html";
    license = licenses.epl20;
    platforms = platforms.all;
    maintainers = with maintainers; [ figsoda ];
  };
}
