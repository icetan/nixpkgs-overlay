{ lib
, writeTextDir
, callPackage
}:

accounts:
let
  tmpls = {
    "generic" = callPackage (import ./generic.nix) {};
    "gmail" = callPackage (import ./gmail.nix) {};
    "outlook" = callPackage (import ./outlook.nix) {};
  };
  mbsyncrc = writeTextDir  "/etc/mbsyncrc"
    (lib.concatMapStringsSep "\n" (a: tmpls."${a.type}" a) accounts);
in
mbsyncrc

#runCommand "isync-wrapper" { buildInputs = [ makeWrapper ]; } ''
#  makeWrapper ${isync}/bin/mbsync $out/bin/mbsync \
#    --add-flags '-c ${isync-conf}'
#  ln -s ${isync}/share $out
#''
