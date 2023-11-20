#!/bin/sh

##### ENV vars #####

GLOO_GATEWAY_V2_CHART_URL="oci://ghcr.io/solo-io/helm-charts/gloo-gateway"

# TODO Check that ENV VARs have been set

if [ -z "$1" ]
then
   echo "Please pass your Gloo Gateway v2 Helm values file as the argument to this installation script."
   exit 1
fi

if [ -z "$GLOO_GATEWAY_V2_VERSION" ]
then
      echo "The 'GLOO_GATEWAY_V2_VERSION' environment variable is empty. This environment variable is required to run the installation."
      exit 1
else
   echo "Installing Gloo Gateway V2 version: $GLOO_GATEWAY_V2_VERSION"
fi

echo "\nCreate gloo-system namespace if it does not yet exist."
kubectl create namespace gloo-system --dry-run=client -o yaml | kubectl apply -f -

echo "\nInstalling Gloo Gateway V2"

helm upgrade --install default $GLOO_GATEWAY_V2_CHART_URL \
    --namespace gloo-system \
    --version $GLOO_GATEWAY_V2_VERSION \
    --values $1