{ pkgs
, inputs
, ...
}:

pkgs.callPackage ({ stdenv, lib, naersk, rust }:

(pkgs.callPackage naersk {
  cargo = rust;
  rustc = rust;
}).buildPackage {
  name = "kak-tree-sitter";
  src = inputs.kak-tree-sitter-src;

  #buildInputs = lib.optionals stdenv.isDarwin [ Security SystemConfiguration ];

  #meta = with lib; {
  #  description = "Kakoune Language Server Protocol Client";
  #  homepage = "https://github.com/kak-lsp/kak-lsp";
  #  license = with licenses; [ unlicense /* or */ mit ];
  #  maintainers = [ maintainers.spacekookie ];
  #};
}) {
  inherit (inputs) naersk;
  inherit (pkgs.rustChannelOf {
    channel = "nightly";
    sha256 = "sha256-HEiNGMs5Nevdu67+nUOZjSsTUrbMFn+nePQ1RQEMqKI=";
    date = "2023-07-13";
  }) rust;
}
