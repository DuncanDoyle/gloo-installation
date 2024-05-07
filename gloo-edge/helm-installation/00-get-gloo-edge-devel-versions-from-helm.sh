#!/bin/sh
helm repo update
helm search repo glooe/gloo-ee --devel --versions
