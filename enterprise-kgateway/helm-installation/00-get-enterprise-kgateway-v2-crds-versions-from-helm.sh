#!/bin/sh

set -eu

URL="us-docker.pkg.dev/solo-public/enterprise-kgateway/charts/enterprise-kgateway-crds"

tags="$(skopeo list-tags "docker://$URL" | jq -r '.Tags[]' | grep -v '^sha256-' | sort -V)"

{
  printf "VERSION\tRELEASED\n"

  for tag in $tags; do
    released="$(
      skopeo inspect --raw "docker://$URL:$tag" |
        jq -r '.annotations."org.opencontainers.image.created" // "" | split("T")[0]'
    )"

    printf "%s\t%s\n" "$tag" "$released"
  done
} | column -t -s '	'
