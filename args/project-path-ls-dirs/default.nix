# (str -> bool) -> str -> [str]
# List directory names in path relative to project root.
{
  filterAttrs,
  projectPath,
  ...
}: fltr: rel: let
  isDir = name: value: value == "directory" && fltr name == true;
  ls = builtins.readDir (projectPath rel);
  dirs = filterAttrs isDir ls;
  dirNames = builtins.attrNames dirs;
in
  builtins.map builtins.unsafeDiscardStringContext dirNames
