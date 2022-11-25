#!/bin/sh

# This is a script to start the cluster. It will start the master nodes and all the workers nodes
echo "Deleting the cluster"
k3d cluster delete local-cluster