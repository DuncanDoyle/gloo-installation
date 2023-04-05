#!/bin/sh

echo "\nCreate Keycloak database secret."
kubectl -n keycloak create secret generic keycloak-db-secret \
  --from-literal=username=postgres \
  --from-literal=password=testpassword


echo "\nDeploy Keycloak."

kubectl apply -f yaml/keycloak-cr.yaml
