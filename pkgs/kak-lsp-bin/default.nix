{ pkgs
, ...
}:

let
  version = "14.2.0";
  tarball = builtins.fetchurl {
    url = "https://github.com/kak-lsp/kak-lsp/releases/download/v${version}/kak-lsp-v14.2.0-x86_64-unknown-linux-musl.tar.gz";
    sha256 = "1v2qh4d9frms9lr72ik1mz46hnnly9nqnvlmvyn4i08rbsg8g87l";
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
