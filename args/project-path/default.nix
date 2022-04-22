{ hasPrefix
, projectSrc
, ...
}:

# Returns an absolute path from a project root relative path.
# str -> path
rel:
if hasPrefix "/" rel
then
  (builtins.path {
    filter = path: type:
      if rel == "/"
      then type != "directory" || builtins.baseNameOf path != ".git"
      else true;
    name =
      if rel == "/"
      then "src"
      else builtins.baseNameOf rel;
    path = (builtins.unsafeDiscardStringContext projectSrc) + rel;
  })
else abort "projectPath arguments must start with: /, currently it is: ${rel}"

