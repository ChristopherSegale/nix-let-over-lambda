{
  description = "Flake for packaging let over lambda lisp library.";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    cl-nix-lite.url = "github:hraban/cl-nix-lite";
    flake-utils.url = "github:numtide/flake-utils";
    lol = {
      url = "github:thephoeron/let-over-lambda";
      flake = false;
    };
  };

  outputs = inputs @ { self, nixpkgs, cl-nix-lite, flake-utils, lol}:
    flake-utils.lib.eachDefaultSystem (system:
    let
      pkgs = nixpkgs.legacyPackages.${system}.extend cl-nix-lite.overlays.default;
      inherit (pkgs.lispPackagesLite) lispDerivation;
    in {
      packages = {
        default = lispDerivation {
          src = lol;
          lispDependencies = with pkgs.lispPackagesLite; [
            alexandria
            cl-ppcre
            named-readtables
            fare-quasiquote-extras
          ];
          lispSystem = "let-over-lambda";
        };
      };
    });
}
