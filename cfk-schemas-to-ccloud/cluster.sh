#!/bin/sh

# This is a script to start the cluster. It will start the master nodes and all the workers nodes
echo "Creating the cluster"
# k3d cluster create local-cluster --servers 1 --agents 3 
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
kubectl -n confluent create secret generic ccloud-sr-credentials --from-file=basic.txt=ccloud-sr-credentials.txt
 
# Connect
echo "Schemas Deploy ..."
kubectl apply -f ./crds/schema-config.yaml

kubectl apply -f ./crds/schema.yaml

kubectl get schema -n confluent

kubectl get schema payment-value -ojsonpath="{.status.version}" -n confluent