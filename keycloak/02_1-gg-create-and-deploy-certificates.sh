#!/bin/sh

echo "\nCreate certificates for Keycloak deployment."

openssl req -subj '/CN=keycloak.example.com/O=solo.io/C=US' -newkey rsa:2048 -nodes -keyout key.pem -x509 -days 365 -out certificate.pem

echo "\nInstall Keycloak certificates as secret in Kubernetes."
kubectl -n gloo-mesh-gateways create secret tls keycloak-tls-secret --cert certificate.pem --key key.pem

rm certificate.pem key.pem


