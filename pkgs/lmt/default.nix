{ pkgs
, inputs
, ...
}: with pkgs;

buildGoPackage rec {
  pname = "lmt";
  version = inputs.lmt-src.lastModifiedDate;

  goPackagePath = "main";

  src = inputs.lmt-src;

  postInstall = ''
    mv $out/bin/main $out/bin/lmt
  '';

  meta = with lib; {
    description = "A literate programming tool for Markdown";
    homepage = "https://github.com/driusan/lmt";
    license = licenses.mit;
    platforms = platforms.all;
  };
}
