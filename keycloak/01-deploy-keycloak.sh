#!/bin/sh

# Create the keycloak namespace if it does not yet exist.
kubectl create namespace keycloak --dry-run=client -o yaml | kubectl apply -f -

# And deploy keycloak
kubectl -n keycloak apply -f yaml/keycloak.yaml

