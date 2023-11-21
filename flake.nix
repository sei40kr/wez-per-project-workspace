{
  inputs = {
    flake-utils.url = "github:numtide/flake-utils";

    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { self, flake-utils, nixpkgs }:
    let
      inherit (flake-utils.lib) eachDefaultSystem;
    in
    eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
        wez-per-project-workspace = pkgs.callPackage ./package.nix { };
      in
      {
        packages = { default = wez-per-project-workspace; };

        devShells = {
          default = pkgs.callPackage ./dev-shell.nix {
            inherit wez-per-project-workspace;
          };
        };
      });
}
