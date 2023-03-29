#!/bin/sh
echo "Adding metallb repo to helm."
helm repo add metallb https://metallb.github.io/metallb

echo "\nUpdating metallb helm repo."
helm repo update metallb

echo "\nInstalling metallb using helm."
helm install metallb metallb/metallb --namespace metallb-system --create-namespace

echo "\nWait for metallb controller deployment to be ready."
kubectl wait deployment -n metallb-system metallb-controller --for condition=Available=True --timeout=90s

echo "\nApplying ip-address-pool configuration."
kubectl apply -f metallb-ip-address-pool.yaml

echo "\nApplying L2 advertisement configuration."
kubectl apply -f metallb-l2-advertisement.yaml


