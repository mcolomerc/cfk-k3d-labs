#!/bin/sh

# This is a script to start the cluster. It will start the master nodes and all the workers nodes
echo "Creating the cluster"
# k3d cluster create local-cluster --servers 1 --agents 3 
k3d cluster create local-cluster --api-port 6550 -p "8080:80@loadbalancer" --agents 5

# Kyverno with Helm > 3.2
echo "Installing Kyverno"
helm repo add kyverno https://kyverno.github.io/kyverno/
helm repo update
helm install kyverno kyverno/kyverno -n kyverno --create-namespace --set replicaCount=3

#Create the namespace for the confluent workloads
echo "Creating the namespace for the confluent workloads"
kubectl create namespace confluent

# Setup the CFK Operator 
echo "Installing the CFK Operator"
helm repo add confluentinc https://packages.confluent.io/helm
helm repo update
helm upgrade --install confluent-operator confluentinc/confluent-for-kubernetes --namespace confluent    

#CP
echo "Deploy Confluent Platform"
kubectl apply -f ./crds/zookeeper.yaml
kubectl apply -f ./crds/kafka.yaml 
kubectl apply -f ./crds/kafkarest.yaml 
kubectl apply -f ./crds/schemaregistry.yaml

# Rules 
echo "Kyverno rules..."
kubectl apply -f ./psc/topic-validation.yaml