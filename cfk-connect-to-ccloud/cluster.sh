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

# Setup Prometheus 
echo "Installing Prometheus"
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo add grafana https://grafana.github.io/helm-charts

helm repo update

helm upgrade --install prometheus prometheus-community/prometheus  \
 --set alertmanager.persistentVolume.enabled=false \
 --set server.persistentVolume.enabled=false \
 --namespace default

echo "Installing Grafana"
helm upgrade --install grafana grafana/grafana --namespace default --values ./grafana/values.yaml
kubectl apply -f ./crds/ingress.yaml

## Credentials 
kubectl -n confluent create secret generic ccloud-credentials --from-file=plain.txt=ccloud-credentials.txt  

kubectl -n confluent create secret generic ccloud-sr-credentials --from-file=basic.txt=ccloud-sr-credentials.txt
 
# Connect
echo "Connect Deploy ..."
kubectl apply -f ./crds/connect.yaml

