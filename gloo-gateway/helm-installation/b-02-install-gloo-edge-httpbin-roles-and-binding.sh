#!/bin/sh

kubectl create namespace httpbin --dry-run=client -o yaml | kubectl apply -f -

printf "Installing the Role and RoleBinding to give Gloo access to the httpbin namespace.\n"
kubectl apply -f gloo-httpbin-rolebinding.yaml