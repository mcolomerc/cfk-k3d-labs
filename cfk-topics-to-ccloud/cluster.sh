#!/bin/sh

# This is a script to start the cluster. It will start the master nodes and all the workers nodes
echo "Creating the cluster" 
k3d cluster create local-cluster --api-port 6550 -p "8080:80@loadbalancer" --agents 1 

#Create the namespace for the confluent workloads
echo "Creating the namespace for the confluent workloads"
kubectl create namespace confluent

# Setup the CFK Operator 
echo "Installing the CFK Operator"
helm repo add confluentinc https://packages.confluent.io/helm
helm repo update
helm upgrade --install confluent-operator confluentinc/confluent-for-kubernetes --namespace confluent  

## Credentials 
kubectl -n confluent create secret generic ccloud-credentials --from-file=bearer.txt=bearer.txt   

#Topic
kubectl apply -f ./crds/topic.yaml

kubectl get topic -n confluent

kubectl describe topic topic-from-cfk -n confluent