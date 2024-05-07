#!/bin/sh

#
# Patches the K8S CoreDNS configmap to rewrite the mc-keycloak.example.com DNS name to the DNS name of the istio-ingressgateway (Gloo Gateway)
# This is needed to route traffic from inside the K8S cluster to domain names that are not registered with a (public) DNS server and for which traffic should be routed to the Gateway.
# In this demo this is needed to route traffic from the internal Microcks container to Microcks Keycloak (mc-keycloak.example.com).
# 

kubectl -n kube-system get configmap coredns -o yaml > coredns-cm.yaml

# Remove rewrites for mc-keycloak.example.com if they exist.
grep -v "rewrite name mc-keycloak.example.com" coredns-cm.yaml > tmpfile && mv tmpfile coredns-cm.yaml
grep -v "rewrite name microcks.example.com" coredns-cm.yaml > tmpfile && mv tmpfile coredns-cm.yaml

# Add rewrites for keycloak.example.com and developer.example.com
sed <<EOF -i'.orig' -e '/ready/ i\
        rewrite name mc-keycloak.example.com istio-ingressgateway.gloo-mesh-gateways.svc.cluster.local \
        rewrite name microcks.example.com istio-ingressgateway.gloo-mesh-gateways.svc.cluster.local
' coredns-cm.yaml
EOF
# Removing the backup file that is created.
rm coredns-cm.yaml.orig

printf "Applying new CoreDNS configmap: "
cat coredns-cm.yaml

kubectl apply -f coredns-cm.yaml
rm coredns-cm.yaml

kubectl -n kube-system rollout restart deployment/coredns
