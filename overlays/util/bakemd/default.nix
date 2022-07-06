{ pkgs
, ...
}:

pkgs.writeShellApplication {
  name = "bakemd";
  runtimeInputs = with pkgs; [ gnused pandoc src-block ];
  text = ''
    usage() {
      if [[ $# -gt 0 ]]; then
        echo >&2 Error: "$@"
      fi
      cat >&2 <<EOF
    Usage: bakemd FILE [THEME]

    Arguments:

      FILE    A Markdown text file
      THEME   A preset theme (default, github)
    EOF
      exit 1
    }

    if [[ $# -lt 1 || $# -gt 2 ]]; then
      usage "Wrong number of arguments"
    fi

    file="$1"
    theme_name="''${2:-default}"
    theme="${./.}/$theme_name.css"

    if [[ ! -f $theme ]]; then
      usage "No theme '$theme_name'"
    fi

    title=$(sed -n 's/^##* \{1,\}//p' "$file" | head -n1)

    pandoc \
      -f gfm -t html5 \
      --metadata pagetitle="$title" \
      --css "$theme" \
      --self-contained \
      <(SB_STYLE=md src-block "$file")
  '';
}
