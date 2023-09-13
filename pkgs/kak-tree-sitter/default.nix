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

  meta = with lib; {
    description = "Syntax hilighting in Kakoune using tree-sitter";
    homepage = "https://github.com/phaazon/kak-tree-sitter";
    license = with licenses; [ unlicense ];
    # maintainers = [ ];
  };
}) {
  inherit (inputs) naersk;
  inherit (pkgs.rustChannelOf {
    channel = "nightly";
    sha256 = "sha256-HEiNGMs5Nevdu67+nUOZjSsTUrbMFn+nePQ1RQEMqKI=";
    date = "2023-07-13";
  }) rust;
}
