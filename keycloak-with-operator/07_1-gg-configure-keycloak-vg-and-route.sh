#!/bin/sh

echo "Create the Keycloak TLS Secret in the Gloo Mesh Gateways namespace."
kubectl -n gloo-mesh-gateways create secret tls keycloak-tls-secret --cert certificate.pem --key key.pem

echo "\nDeploy Keycloak Virtual Gateway."
kubectl apply -f yaml/keycloak-gg-vg.yaml

echo "\nDeploy Keycloak RouteTable."
kubectl apply -f yaml/keycloak-gg-rt.yaml

