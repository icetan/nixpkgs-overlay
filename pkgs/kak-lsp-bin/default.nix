{ pkgs
, ...
}:

let
  version = "16.0.0";
  tarball = builtins.fetchurl {
    url = "https://github.com/kakoune-lsp/kakoune-lsp/releases/download/v${version}/kakoune-lsp-v${version}-x86_64-unknown-linux-musl.tar.gz";
    sha256 = "04f2ps8b4p2p0cc71d38ywx116p04laaiynsmhhz423mxqys03cs";
  };
in
pkgs.runCommand "kak-lsp-bin" {
  inherit version;
  # meta = with pkgs.lib; {
  #   description = "Kakoune Language Server Protocol Client";
  #   homepage = "https://github.com/kak-lsp/kak-lsp";
  #   license = with licenses; [ unlicense /* or */ mit ];
  #   maintainers = [ maintainers.spacekookie ];
  # };
} ''
  tar xzvf ${tarball}
  mkdir -p $out/bin $out/share/kak-lsp
  mv kak-lsp $out/bin
  mv * $out/share/kak-lsp
''
