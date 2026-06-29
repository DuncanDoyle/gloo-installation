#!/bin/sh

set -eu

helm repo update
# helm search repo glooe/gloo-ee --devel --versions

index_file="$(helm env HELM_REPOSITORY_CACHE | tr -d '"')/glooe-index.yaml"

dates="$(
  yq -o=json '.entries."gloo-ee"' "$index_file" |
    jq 'map({(.version): ((.created // "") | split("T")[0])}) | add'
)"

helm search repo glooe/gloo-ee --devel --versions -o json |
  jq -r --argjson dates "$dates" '
    ["NAME", "CHART VERSION", "RELEASED", "DESCRIPTION"],
    (.[] | [
      .name,
      .version,
      ($dates[.version] // ""),
      (.description // "")
    ])
    | @tsv
  ' |
  column -t -s '	'