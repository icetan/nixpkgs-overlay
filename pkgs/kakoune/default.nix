{ inputs
, pkgs
, ...
}:

let
  inherit (inputs) kakoune-src;
  inherit (pkgs) kakoune lib;
  inherit (lib) substring replaceStrings importJSON;

  kakoune-unstable = kakoune.overrideDerivation (_attrs: rec {
    src = kakoune-src;
    version = kakoune-src.lastModifiedDate;
    name = "kakoune-git-${version}";
    #buildInputs = _attrs.buildInputs ++ [ pkgconfig ];
  });
in
kakoune-unstable
