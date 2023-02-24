#!/bin/sh


# This is a script to start the cluster. It will start the master nodes and all the workers nodes
echo "\n Registry - Creating the registry"
echo "----------------------------" 
k3d registry create app-registry --port 5050


# This is a script to start the cluster. It will start the master nodes and all the workers nodes
echo "\n Source cluster - Creating the cluster"
echo "----------------------------"
k3d cluster create local-cluster --servers 1 --agents 3 \
    -p "9900:80@loadbalancer" \
    --k3s-arg '--kubelet-arg=eviction-hard=imagefs.available<1%,nodefs.available<1%@agent:*' \
    --k3s-arg '--kubelet-arg=eviction-minimum-reclaim=imagefs.available=1%,nodefs.available=1%@agent:*' \
    --registry-use k3d-app-registry:5050 --registry-config registry.yaml

echo "\n Source cluster - Set kubectl context ..."
echo "----------------------------"
kubectl config use-context k3d-local-cluster
 
kubectl config current-context 

#Create the namespace for the confluent workloads
echo "\n Source cluster - Creating the namespace for the confluent workloads"
echo "----------------------------"
kubectl create namespace confluent

# Setup the CFK Operator 
echo "\n Installing the CFK Operator"
echo "----------------------------"
helm repo add confluentinc https://packages.confluent.io/helm
helm repo update
helm upgrade --install confluent-operator \
  confluentinc/confluent-for-kubernetes \
  --namespace default --set namespaced=false

echo "\n CFKs - Deployment..."
echo "----------------------------"
echo "----------------------------"

echo "\n Source cluster "
echo "----------------------------"
kubectl create namespace source
 
kubectl apply -f ./cfk/source  

echo "\n Destination cluster "
echo "----------------------------"
kubectl create namespace dest
  
kubectl apply -f ./cfk/dest  

echo "----------------------------"

echo "\n Source cluster - Get Topic ..."
echo "----------------------------"
kubectl get topic -n source 

echo "\n Source cluster - Get Connect ..."
echo "----------------------------"
kubectl get connect -n source  

echo "\n Control Center - Deployment..."
echo "----------------------------"
kubectl apply -f ./cfk/confluent/controlcenter.yaml

echo "\n Control Center - Ingress ..."
echo "----------------------------"
kubectl apply -f ./cfk/confluent/ingress.yaml

echo "Open the Control Center UI at http://localhost:9900"