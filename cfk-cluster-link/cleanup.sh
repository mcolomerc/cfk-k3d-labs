#!/bin/sh

echo "\n  Delete k3d cluster"
echo "----------------------------"
k3d cluster delete local-cluster


echo "\n Delete registry"
echo "----------------------------"
k3d registry delete k3d-app-registry 

echo "\n Clusters..."
echo "----------------------------"
k3d cluster list 