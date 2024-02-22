{ flake ? builtins.getFlake (toString ../..)
, inputs ? flake.inputs
, pkgs ? flake.outputs.legacyPackages.${builtins.currentSystem}.pkgs
}:
let
  python = pkgs.python311;
  poetry2nix = inputs.poetry2nix.lib.mkPoetry2Nix { inherit pkgs; };
  inherit (poetry2nix)
    mkPoetryEnv defaultPoetryOverrides;

  pyEnv = mkPoetryEnv {
    inherit python;
    projectDir = ./.;
    preferWheels = true;
    overrides = defaultPoetryOverrides.extend (import ./overrides.nix {
      inherit pkgs python;
    });
  };
in

pyEnv.env.overrideAttrs (old: {
  buildInputs = [
    pkgs.poetry
  ];
})
