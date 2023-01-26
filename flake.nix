{
  inputs = {
    nixpkgs.url = "nixpkgs";

    utils.url = "flake-utils";
    #utils.inputs.nixpkgs.follows = "nixpkgs";

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

  outputs = { self, utils, nixpkgs, nil, ... }@inputs:
    let
      legacy-overlay = import ./overlays/util;
      pkgs-overlay = final: prev: (import ./args {
        inherit (prev) system;
        inherit inputs;
        pkgs = prev;
      }).packages;

      overlays = [
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
