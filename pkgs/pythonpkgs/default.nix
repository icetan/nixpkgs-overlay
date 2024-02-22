{ pkgs
, inputs
, ...
}:
let
  python = pkgs.python311;
  poetry2nix = inputs.poetry2nix.lib.mkPoetry2Nix { inherit pkgs; };

  inherit (poetry2nix)
    mkPoetryPackages defaultPoetryOverrides;

  pyPkgs = mkPoetryPackages {
    inherit python;
    projectDir = ./.;
    preferWheels = true;
    overrides = defaultPoetryOverrides.extend (import ./overrides.nix {
      inherit pkgs python;
    });
  };

  extraPkgs = builtins.listToAttrs
    (map
      (p: { name = p.pname; value = p; })
      pyPkgs.poetryPackages
    );
in
{
  inherit (extraPkgs) aider-chat;
}
