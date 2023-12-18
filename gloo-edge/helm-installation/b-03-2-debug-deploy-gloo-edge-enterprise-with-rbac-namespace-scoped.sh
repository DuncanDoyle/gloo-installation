#!/bin/sh

# NOTE THAT WE SKIP THE CRDS!!!!! So those need to be installed first!
#helm upgrade --install --skip-crds gloo glooe/gloo-ee --namespace gloo-system-ddoyle --create-namespace --set-string license_key=$(cat ~/.gloo/gloo-edge-license-key) --set gloo-fed.enabled=false -f values-gloorbac-namespaced.yaml --version $1


helm upgrade --install --debug --skip-crds gloo glooe/gloo-ee --namespace gloo-system --create-namespace --set-string license_key=$(cat ~/.gloo/gloo-edge-license-key) --set gloo-fed.enabled=false -f values-gloorbac-namespaced.yaml --version $1
