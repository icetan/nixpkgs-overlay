{ pkgs
, ...
}:

let
  version = "17.0.1";
  tarball = builtins.fetchurl {
    url = "https://github.com/kakoune-lsp/kakoune-lsp/releases/download/v${version}/kakoune-lsp-v${version}-x86_64-unknown-linux-musl.tar.gz";
    sha256 = "1pqii40g3rxva0kxi3rgq3a914s3kx82s59ypchw2a5asgwp2yaa";
  };
in
pkgs.runCommand "kak-lsp-bin-${version}" {
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
