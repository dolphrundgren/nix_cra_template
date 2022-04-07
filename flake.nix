{
  description = "A cra test!";

  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    nix-cra-template-src = {
      url = "github:dolphrundgren/nix_cra_template/v1.0.0";
      flake = false;
    };
  };

  outputs = { self, nixpkgs, flake-utils, nix-cra-template-src }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          overlays = [ self.overlay ];
        };
      in rec {
        packages.nix-cra-template = pkgs.nix-cra-template;

        defaultPackage = pkgs.nix-cra-template;

        devShell = pkgs.mkShell { buildInputs = [ pkgs.nix-cra-template]; };
      }) // {
        overlay = (final: prev: {
          nix-cra-template = prev.mkYarnPackage {
            name = "nix-cra-template";
            src = nix-cra-template-src;
            packageJSON = ./package.json;
            yarnLock = ./yarn.lock;
          };
        });
      };
}
