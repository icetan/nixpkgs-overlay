{ pkgs
, inputs
, ...
}:

pkgs.callPackage ({ stdenv, lib, fetchFromGitHub, rustPlatform, Security, SystemConfiguration }:

rustPlatform.buildRustPackage {
  pname = "kak-lsp";
  version = "14.2.0";

  src = inputs.kak-lsp-src;
  cargoSha256 = "sha256-cFBHoasdKplJO6juytAQQemqMZ+6ry+I/PjqIm+DIYY=";

  #src = fetchFromGitHub {
  #  owner = pname;
  #  repo = pname;
  #  rev = "v${version}";
  #  sha256 = "sha256-K2GMoLaH7D6UtPuL+GJMqsPFwriyyi7WMdfzBmOceSA=";
  #};
  #cargoSha256 = "sha256-suBBEHGHUlZyxKy5hwhc2K/qTNis75GY33+7QhpmGos=";

  buildInputs = lib.optionals stdenv.isDarwin [ Security SystemConfiguration ];

  meta = with lib; {
    description = "Kakoune Language Server Protocol Client";
    homepage = "https://github.com/kak-lsp/kak-lsp";
    license = with licenses; [ unlicense /* or */ mit ];
    maintainers = [ maintainers.spacekookie ];
  };
}) {
  inherit (pkgs.darwin.apple_sdk.frameworks) Security SystemConfiguration;
}
