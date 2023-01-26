{
  inputs = {
    nixpkgs-stable.url = "github:NixOS/nixpkgs/release-22.05";

    nixpkgs.url = "nixpkgs";

    utils.url = "flake-utils";

    ln-conf.url = "github:icetan/ln-conf";
    ln-conf.inputs.nixpkgs.follows = "nixpkgs";

    kakoune-src.url = "github:mawww/kakoune";
    kakoune-src.flake = false;

    kak-lsp-src.url = "github:kak-lsp/kak-lsp/v12.1.0";
    kak-lsp-src.flake = false;

    pairon-src.url = "github:icetan/pairon";
    pairon-src.flake = false;

    lmt-src.url = "github:driusan/lmt";
    lmt-src.flake = false;

    nil.url = "github:oxalica/nil";
  };

  outputs = { self, utils, nixpkgs, nixpkgs-stable, nil, ... }@inputs:
    let
      stable-overlay = final: prev: let
        pkgs = import nixpkgs-stable { inherit (prev) system; };
      in {
        inherit (pkgs) khal;
      };
      legacy-overlay = import ./overlays/util;
      pkgs-overlay = final: prev: (import ./args rec {
        inherit (prev) system;
        inherit inputs;
        pkgs = prev;
        #pkgs-stable = import nixpkgs-stable { inherit system; };
      }).packages;

      overlays = [
        stable-overlay
        legacy-overlay
        pkgs-overlay
      ];

      overlays' = {
        overlays = rec {
          all = final: prev: builtins.foldl' (acc: o: acc // o final prev) { } overlays;
          default = all;
        };
      };

      systems = utils.lib.eachDefaultSystem (system: {
        legacyPackages = import nixpkgs { inherit system overlays; };
      });
    in
    systems // overlays';
}
