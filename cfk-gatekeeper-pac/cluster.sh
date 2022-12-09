#!/bin/sh

# This is a script to start the cluster. It will start the master nodes and all the workers nodes
echo "Creating the cluster"
# k3d cluster create local-cluster --servers 1 --agents 3 
k3d cluster create local-cluster --api-port 6550 -p "8080:80@loadbalancer" --agents 5

# gatekeeper
echo "Installing Gatekeeper"
helm repo add gatekeeper https://open-policy-agent.github.io/gatekeeper/charts --force-update
helm repo update
helm install gatekeeper/gatekeeper --name-template=gatekeeper --namespace gatekeeper-system --create-namespace

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
echo "OPA rules..."
kubectl apply -f ./pac/topic-template.yaml
kubectl apply -f ./pac/topic-constraint.yaml
