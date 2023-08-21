{
  inputs = {
    nixpkgs-stable.url = "github:NixOS/nixpkgs/release-22.05";

    nixpkgs.url = "nixpkgs";

    utils.url = "flake-utils";
    naersk.url = "github:nix-community/naersk";

    nixpkgs-mozilla.url = "github:mozilla/nixpkgs-mozilla";
    nixpkgs-mozilla.flake = false;

    ln-conf.url = "github:icetan/ln-conf";
    ln-conf.inputs.nixpkgs.follows = "nixpkgs";

    pairon-src.url = "github:icetan/pairon";
    pairon-src.flake = false;

    lmt-src.url = "github:driusan/lmt";
    lmt-src.flake = false;

    kak-lsp-src.url = "github:kak-lsp/kak-lsp";
    kak-lsp-src.flake = false;

    kak-tree-sitter-src.url = "github:phaazon/kak-tree-sitter";
    kak-tree-sitter-src.flake = false;
  };

  outputs = { self, utils, nixpkgs, nixpkgs-stable, nixpkgs-mozilla, ... }@inputs:
    let
      stable-overlay = final: prev: let
        pkgs = import nixpkgs-stable { inherit (prev) system; };
      in {
        inherit (pkgs) khal;
      };
      legacy-overlay = import ./overlays/util;
      mozilla-overlay = import nixpkgs-mozilla;
      pkgs-overlay = final: prev: (import ./args rec {
        inherit (prev) system;
        inherit inputs;
        pkgs = prev;
        #pkgs-stable = import nixpkgs-stable { inherit system; };
      }).packages;

      overlays = [
        stable-overlay
        legacy-overlay
        mozilla-overlay
        pkgs-overlay
      ];

      systems = utils.lib.eachDefaultSystem (system: {
        legacyPackages = import nixpkgs { inherit system overlays; };
      });
    in
    systems // {
      overlays.default = overlays;
    };
}
