# Gloo Edge setup


## Namespaced setup
The namespace scoped installation of Gloo Edge is done via the scripts starting with "b-".
These scripts first install the CRDs ("b-01"), after which we install the Role and RoleBinding required for Gloo Edge to watcht 'httpbin' namespace ("b-02").
Finally we install Gloo Edge in the 'gloo-system' namespace and configure it to watch the 'gloo-system' and 'httpbin' namespace.

The idea is that we want to install Gloo Edge without the need to have full cluster access. This is useful in multi-tenant Kubernetes deployments,
where the ops team doesn't want to hand out full cluster-scoped permissions.

Not that in the current setup, 3 ClusterRoles are still created:
- gloo-gateway-vwc-update
- glooe-prometheus-kube-state-metrics-v2
- glooe-prometheus-server

Prometheus can probably run namespace scoped, but this is not something that has been investigated:  https://stackoverflow.com/questions/72782946/is-it-possible-to-get-pod-metrics-from-prometheus-without-rbac

The 'gloo-gateway-vwc-update' cluster-role is needed for the certgen job to update the validating webhook config's caBundle. Since validatingwebhookconfig is cluster-scoped, it can only be done via a clusterrole
