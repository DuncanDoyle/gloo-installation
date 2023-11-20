#!/bin/sh
 
# This doesn't work on OCI repositories
# helm search repo oci://ghcr.io/solo-io/helm-charts/gloo-gateway

json=$(skopeo list-tags docker://ghcr.io/solo-io/helm-charts/gloo-gateway)
tags=$(skopeo list-tags docker://ghcr.io/solo-io/helm-charts/gloo-gateway | jq -r '.Tags.[]')
printf "\nTags:\n$tags\n"

# for row in $tags; do
#     skopeo inspect --config --raw docker://ghcr.io/solo-io/helm-charts/gloo-gateway:$row | jq -r
# done

latest_tag=$(echo "$tags" | tail -n1)

printf "\nLatest tag: $latest_tag\n"

skopeo inspect --config --raw docker://ghcr.io/solo-io/helm-charts/gloo-gateway:$latest_tag | jq -r