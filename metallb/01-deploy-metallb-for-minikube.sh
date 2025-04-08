#!/bin/sh

if [ -z "$1" ]
  then
    echo "You must specify a Minikube profile name."
    exit 1
fi

MINIKUBE_PROFILE=$1

####################### First make sure we can determine the address-pool we want to use for metallb. #######################

# Get the ip address of the primary control plane node
MINIKUBE_IP=$(minikube -p $MINIKUBE_PROFILE ip)

if [ -z "$MINIKUBE_IP" ]
  then
    echo "Unable to determine the ip address of the control plane node."
    exit 1
fi

printf "\nMinikube IP is: $MINIKUBE_IP\n\n"

# Extract first three octets
IFS='.' read -r o1 o2 o3 o4 <<< "$MINIKUBE_IP"
BASE_ADDRESS="${o1}.${o2}.${o3}"

# Create the address pool string
export ADDRESS_POOL="${BASE_ADDRESS}.50-${BASE_ADDRESS}.100"

####################### Install MetalLB #######################

echo "Adding metallb repo to helm."
helm repo add metallb https://metallb.github.io/metallb

echo "\nUpdating metallb helm repo."
helm repo update metallb

# Removing label from all nodes, so we don't have to know the node-names
echo "\nRemove 'exclude-from-external-load-balancers' from all nodes\n"
kubectl label nodes --all node.kubernetes.io/exclude-from-external-load-balancers-

echo "\nInstalling metallb using helm."
helm install metallb metallb/metallb --namespace metallb-system --create-namespace

echo "\nWait for metallb controller deployment to be ready."
kubectl wait deployment -n metallb-system metallb-controller --for condition=Available=True --timeout=90s

echo "\nApplying L2 advertisement configuration."
kubectl apply -f metallb-l2-advertisement.yaml

# Using the addresspool we computed at the start of this script.
echo "\nApplying ip-address-pool configuration."
echo "\nUsing address-pool: $ADDRESS_POOL.\n"
envsubst < metallb-ip-address-pool-template.yaml | kubectl apply -f -
