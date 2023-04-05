#!/bin/sh

echo "\nUsername: " 
kubectl -n keycloak get secret keycloak-initial-admin -o jsonpath='{.data.username}' | base64 --decode

echo

echo "\nPassword: "
kubectl -n keycloak get secret keycloak-initial-admin -o jsonpath='{.data.password}' | base64 --decode
echo "\n"


