#!/bin/sh

# Create the argocd namespace if it does not yet exist.
kubectl create namespace argocd --dry-run=client -o yaml | kubectl apply -f -
