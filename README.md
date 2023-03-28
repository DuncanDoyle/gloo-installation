# Gloo Installation scripts

Repository with a bunch of scripts and Helm commands to install the [solo.io](https://solo.io) Gloo products:

* Gloo Edge
* Gloo Mesh
* Gloo Platform
* Gloo Portal

The repository also contains some scripts to install the [MetalLb](https://metallb.universe.tf/) Kubernetes load-balancer, which can be useful when you run Kubernetes on bare-metal or in a container (e.g. minikube).

NOTE: The Gloo Edge installation scripts install Gloo Edge Enterprise and require a license-key. The installation scripts retrieve this key from the text-file in `~/.gloo/gloo-edge-license-key`. Hence that text-file, with a correct key, is required to successfully run the Gloo Edge Enterprise installation.