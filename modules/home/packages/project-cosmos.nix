# Project Cosmos (https://projectcosmos.app) - Windows-only Unity MMO.
# The official launcher is .NET + WebView2 (painful under Wine), so this
# replaces it: sync the game files straight from the launcher manifest
# (sha256-verified), then run the game under Proton via umu.
{
  writeShellApplication,
  curl,
  jq,
  brotli,
  umu-launcher,
  proton-ge-bin,
}:
writeShellApplication {
  name = "project-cosmos";
  runtimeInputs = [
    curl
    jq
    brotli
    umu-launcher
  ];
  text = ''
    dir="''${COSMOS_DIR:-$HOME/Games/ProjectCosmos}"
    mkdir -p "$dir" && cd "$dir"
    curl -fsSL https://builds.projectcosmos.app/prod/current/launcher_manifest.json -o .manifest.json
    base=$(jq -r .packageBaseUrl .manifest.json)
    export base

    fetch() {
      IFS=$'\t' read -r sha path url recipe <<<"$1"
      # manifest is remote input: never write outside the install dir
      case "$path" in /* | *..*) echo "refusing path: $path" >&2; return 1 ;; esac
      echo "$sha  $path" | sha256sum -c --status 2>/dev/null && return 0
      mkdir -p "$(dirname "$path")"
      if [ -n "$recipe" ]; then
        # big files only exist as brotli chunks: .patches/objects/<encodedSha256>, concatenated in recipe order
        tmp=$(mktemp -d .chunks.XXXXXX)
        curl -fsSL --retry 5 "$base/$recipe" -o "$tmp/recipe.json"
        jq -r '.chunks[].encodedSha256' "$tmp/recipe.json" | sort -u |
          sed "s|.*|url = \"$base/.patches/objects/&\"\noutput = \"$tmp/&\"|" >"$tmp/curl.cfg"
        curl -fsS --retry 5 --parallel --parallel-max 16 -K "$tmp/curl.cfg"
        jq -r '.chunks[] | "\(.encodedSha256) \(.encoding)"' "$tmp/recipe.json" |
          while read -r h enc; do
            case "$enc" in br) brotli -dc "$tmp/$h" ;; *) cat "$tmp/$h" ;; esac
          done >"$path"
        rm -rf "$tmp"
      else
        curl -fsSL --retry 5 "$base/$url" -o "$path"
      fi
      echo "$sha  $path" | sha256sum -c --status || { echo "hash mismatch: $path" >&2; rm -f "$path"; return 1; }
      echo "ok $path"
    }
    export -f fetch

    # only re-verify when the published manifest changed (or last sync failed)
    if ! cmp -s .manifest.json .installed.json; then
      # shellcheck disable=SC2016
      jq -r '.files[] | [.sha256, .path, (.path | split("/") | map(@uri) | join("/")), (.chunkRecipe.path // "")] | @tsv' .manifest.json |
        xargs -d '\n' -P 8 -n 1 bash -c 'fetch "$0"'
      cp .manifest.json .installed.json
    fi

    export WINEPREFIX="$dir/.prefix" GAMEID=umu-default
    export PROTONPATH="''${PROTONPATH:-${proton-ge-bin.steamcompattool}}"
    exec umu-run "$(jq -r .executableRelativePath .manifest.json)" "$@"
  '';
}
