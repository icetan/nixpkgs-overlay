{ inputs
, pkgs
, system
, ...
}:

let
  packages = args.importDirs "/pkgs";

  args = {
    inherit inputs;
    inherit system;
    inherit pkgs;

    ln-conf = inputs.ln-conf.packages.${system}.default;
    nil = inputs.nil.packages.${system}.nil;

    optinalAttrs = pkgs.lib.optinalAttrs;
    hasPrefix = pkgs.lib.hasPrefix;
    filterAttrs = pkgs.lib.filterAttrs;
    compose = f: g: x: f (g x);
    trc = t: x: builtins.trace "${t}: ${builtins.toJSON x}" x;

    projectSrc = inputs.self.sourceInfo.outPath;
    projectPath = import ./project-path args;
    projectPathLsDirs = import ./project-path-ls-dirs args;
    importDirs = import ./import-dirs args;

    mkMailEnv = import ./mk-mail-env args;

    packages = packages // {
      inherit (args) mkMailEnv;
    };
  };
in
args
