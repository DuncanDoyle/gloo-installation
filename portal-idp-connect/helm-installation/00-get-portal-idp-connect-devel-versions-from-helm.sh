#!/bin/sh
helm repo update
helm search repo gloo-portal-idp-connect/gloo-portal-idp-connect --devel --versions
