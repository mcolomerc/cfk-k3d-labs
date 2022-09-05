#!/bin/sh

export APP_NAME=go-consumer

export DOCKER_REPO=localhost:5050

export K3D_REGISTRY=k3d-app-registry:5050

make build 

make tag-latest

make publish-latest

make k3d_deploy

