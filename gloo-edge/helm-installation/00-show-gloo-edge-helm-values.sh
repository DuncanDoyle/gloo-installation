#!/bin/sh

VERSION=$1

helm show values glooe/gloo-ee --version $VERSION

