#!/bin/sh
echo "\nDeploy Keycloak Virtual Service."
kubectl apply -f yaml/keycloak-ge-vs.yaml