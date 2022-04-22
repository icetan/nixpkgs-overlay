{
  inputs = {
    nixpkgs.url = "nixpkgs";

    utils.url = "flake-utils";
    utils.inputs.nixpkgs.follows = "nixpkgs";

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
  };

  outputs = { self, utils, nixpkgs, ... }@inputs:
    utils.lib.eachDefaultSystem (system:
      let
        overlay-legacy = import ./overlays/util;
        overlay = final: prev: (import ./args {
          inherit system;
          inherit inputs;
          pkgs = prev;
        }).packages;

        overlays = [ overlay-legacy overlay ];

        legacyPackages = import nixpkgs { inherit system overlays; };
      in
      {
        inherit legacyPackages overlays;
      });
}
