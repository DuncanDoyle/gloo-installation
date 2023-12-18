#!/bin/sh

printf "Installing the Gloo Edge CRDs for version $1.\n"

mkdir tmp
pushd tmp

printf "\nFetching the Gloo Edge Helm charts for version $1.\n"
helm pull glooe/gloo-ee --untar --version $1

printf "\nInstalling the Gloo Edge CRDs.\n"
kubectl apply -f gloo-ee/charts/gloo/crds

popd
rm -rf tmp
