#!/bin/sh

##### ENV vars #####

# TODO Check that ENV VARs have been set

if [ -z "$GLOO_GATEWAY_LICENSE_KEY" ]
then
      echo "The 'GLOO_GATEWAY_LICENSE_KEY' environment variable is empty. This environment variable is required to run the installation."
      exit 1
else
   echo "Found Gloo Gateway license key."
fi

if [ -z "$GLOO_VERSION" ]
then
      echo "The 'GLOO_VERSION' environment variable is empty. This environment variable is required to run the installation."
      exit 1
else
   echo "Installing Gloo version: $GLOO_VESRION"
fi

if [ -z "$CLUSTER_NAME" ]
then
      echo "The 'CLUSTER_NAME' environment variable is empty. This environment variable is required to run the installation."
      exit 1
else
   echo "Using cluster name: $CLUSTER_NAME"
fi

##### meshctl installaiton #####

# echo "\nInstall meshctl version: $GLOO_VERSION"

# # Gloo mesh install
# BIN_DIR="$(pwd)/.gloo-mesh/bin"
# mkdir -p ${BIN_DIR}
# MESHCTL_BIN="${BIN_DIR}/meshctl"
# rm ${MESHCTL_BIN} || true
# #wget "https://storage.googleapis.com/gloo-platform-dev/meshctl/${GLOO_VERSION}/meshctl-darwin-arm64" -O ${MESHCTL_BIN}
# wget "https://storage.googleapis.com/meshctl/${MESHCTL_VERSION}/meshctl-darwin-arm64" -O ${MESHCTL_BIN}
# chmod +x ${MESHCTL_BIN}

# ${MESHCTL_BIN} version

##### Install Gloo Platform CRDs #####

echo "\nInstalling Gloo Platform CRDs"

helm upgrade --install gloo-platform-crds gloo-platform/gloo-platform-crds \
   --namespace=gloo-mesh \
   --create-namespace \
   --version $GLOO_VERSION

##### Install Gloo Platform #####

echo "Create gloo-mesh-addons namespace if it does not yet exist."
kubectl create namespace gloo-mesh-addons --dry-run=client -o yaml | kubectl apply -f -

echo "\nInstalling Gloo Platform"

helm upgrade --install gloo-platform gloo-platform/gloo-platform \
   --namespace gloo-mesh \
   --version $GLOO_VERSION \
   --values gloo-gateway.yaml \
   --set common.cluster=$CLUSTER_NAME \
   --set licensing.glooGatewayLicenseKey=$GLOO_GATEWAY_LICENSE_KEY