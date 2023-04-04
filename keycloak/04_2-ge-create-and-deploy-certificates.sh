#!/bin/sh

echo "\nCreate certificates for Keycloak deployment."

openssl req -subj '/CN=keycloak.example.com/O=solo.io/C=US' -newkey rsa:2048 -nodes -keyout key.pem -x509 -days 365 -out certificate.pem

echo "\nInstall Keycloak certificates as secret in Kubernetes."
kubectl -n keycloak create secret tls keycloak-tls-secret --cert certificate.pem --key key.pem
kubectl -n gloo-system create secret tls keycloak-tls-secret --cert certificate.pem --key key.pem

rm certicate.pem key.pem


