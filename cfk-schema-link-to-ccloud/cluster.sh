#!/bin/sh

# This is a script to start the cluster. It will start the master nodes and all the workers nodes
echo "Creating the cluster"
# k3d cluster create local-cluster --servers 1 --agents 3 
k3d cluster create local-cluster --api-port 6550 -p "8080:80@loadbalancer" --agents 3

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

kubectl -n confluent create secret generic ccloud-sr-secret --from-file=password-encoder.txt=password-encoder.txt

# CP
kubectl apply -f ./crds/zookeeper.yaml
kubectl apply -f ./crds/kafka.yaml

kubectl apply -f ./crds/schemaregistry.yaml

# SR Ingress - http://localhost:8080/exporters/payment-schema-exporter
kubectl apply -f ./crds/ingress.yaml

kubectl apply -f ./crds/schema-config.yaml
kubectl apply -f ./crds/schema.yaml
kubectl apply -f ./crds/schemaexporter.yaml