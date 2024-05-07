#!/bin/sh

# Create the microcks namespace if it does not yet exist.
kubectl create namespace microcks --dry-run=client -o yaml | kubectl apply -f -

#helm install microcks microcks/microcks --version 1.7.1 --namespace microcks --set microcks.url=microcks.127.0.0.1.nip.io --set keycloak.url=keycloak.127.0.0.1.nip.io
#helm install microcks microcks/microcks --version 1.7.1 --namespace microcks --set ingresses=false  --set microcks.url=microcks.example.com --set keycloak.url=mc-keycloak.example.com
helm install microcks microcks/microcks --version 1.7.1 --namespace microcks --set ingresses=false  --set microcks.url=microcks.example.com --set keycloak.url=mc-keycloak.example.com
