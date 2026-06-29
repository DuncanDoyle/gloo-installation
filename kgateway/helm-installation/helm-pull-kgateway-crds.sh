#!/bin/sh

if [[ -z "$1" ]]; then
    echo "Please specify the version number of the kgateway helm chart you want to pull."
    exit 1
fi

URL=cr.kgateway.dev/kgateway-dev/charts/kgateway-crds

helm pull oci://$URL --version $1