#!/bin/sh

KEYCLOAK_VERSION=21.0.2

# First apply the Keycloak CRDs
echo "\nDeploying Keycloak CRDs."
kubectl apply -f https://raw.githubusercontent.com/keycloak/keycloak-k8s-resources/$KEYCLOAK_VERSION/kubernetes/keycloaks.k8s.keycloak.org-v1.yml
kubectl apply -f https://raw.githubusercontent.com/keycloak/keycloak-k8s-resources/$KEYCLOAK_VERSION/kubernetes/keycloakrealmimports.k8s.keycloak.org-v1.yml

# Install the Keycloak Operator
# Note that the Operator currently only watches the namespaces in which it itself is installed
echo "\nCreate the keycloak namespace."
kubectl create ns keycloak

echo "\nInstalling the Keycloak Operator."
kubectl -n keycloak apply -f https://raw.githubusercontent.com/keycloak/keycloak-k8s-resources/$KEYCLOAK_VERSION/kubernetes/kubernetes.yml
