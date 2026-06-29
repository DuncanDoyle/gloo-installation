#!/bin/sh

if [[ -z "$1" ]]; then
    echo "Please specify the version number of the agentgateway helm chart you want to pull."
    exit 1
fi

URL=us-docker.pkg.dev/solo-public/gloo-gateway/charts/enterprise-agentgateway-crds

helm pull oci://$URL --version $1
