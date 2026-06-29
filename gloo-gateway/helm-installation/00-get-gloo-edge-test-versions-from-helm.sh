#!/bin/sh
helm repo update
helm search repo gloo-ee-test/gloo-ee --devel --versions
