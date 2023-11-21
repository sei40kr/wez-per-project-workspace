{ lib, stdenv }:

stdenv.mkDerivation {
  name = "wez-per-project-workspace";

  src = ./.;

  dontBuild = true;

  installPhase = ''
    cp -r plugin $out;
  '';
}
