{ projectPath
, projectPathLsDirs
, compose
, trc
, ...
}@args:

# str -> attrs
dir:
let
  exprPath = name: "${projectPath dir}/${name}/default.nix";
  dirs = projectPathLsDirs
    (compose builtins.pathExists exprPath)
    dir;
  imports = map
    (name: { inherit name; value = import (exprPath name) args; })
    dirs;
in
builtins.listToAttrs imports
