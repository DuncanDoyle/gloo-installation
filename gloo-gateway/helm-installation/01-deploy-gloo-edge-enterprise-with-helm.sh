#!/bin/sh

helm upgrade --install gloo glooe/gloo-ee --namespace gloo-system --create-namespace --set-string license_key=$(cat ~/.gloo/gloo-edge-license-key) -f values-gateway-access-logging.yaml --version $1
