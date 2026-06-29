#!/bin/sh

# This doesn't work on OCI repositories
# helm search repo oci://ghcr.io/solo-io/helm-charts/gloo-gateway

# export URL="us-docker.pkg.dev/developers-369321/gloo-gateway/charts/gloo-gateway"

echo "TODO: Find the URL of the nigthly builds for Solo Enterprise for Kgateway"

exit 1

json=$(skopeo list-tags docker://$URL)
tags=$(echo $json | jq -r '.Tags.[]' | grep -v '^sha256-')
printf "\nTags:\n$tags\n"

# for row in $tags; do
#     skopeo inspect --config --raw docker://ghcr.io/solo-io/helm-charts/gloo-gateway:$row | jq -r
# done

latest_tag=$(echo "$tags" | tail -n1)

printf "\nLatest tag: $latest_tag\n"

skopeo inspect --config --raw docker://$URL:$latest_tag | jq -r