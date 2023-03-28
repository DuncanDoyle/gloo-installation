#!/bin/sh

helm upgrade --install gloo-portal gloo-portal/gloo-portal --namespace gloo-portal --create-namespace --values gloo-values.yaml --version $1
