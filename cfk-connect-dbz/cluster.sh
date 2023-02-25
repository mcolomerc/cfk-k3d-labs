#!/bin/sh

k3d registry create app-registry --port 5050

# This is a script to start the cluster. It will start the master nodes and all the workers nodes
echo "Creating the cluster"
# k3d cluster create local-cluster --servers 1 --agents 3 
k3d cluster create local-cluster --servers 1 --api-port 6550 -p "8080:80@loadbalancer" --agents 5  \
    --k3s-arg '--kubelet-arg=eviction-hard=imagefs.available<1%,nodefs.available<1%@agent:*' \
    --k3s-arg '--kubelet-arg=eviction-minimum-reclaim=imagefs.available=1%,nodefs.available=1%@agent:*' \
    --registry-use k3d-app-registry:5050 --registry-config registry.yaml

#Create the namespace for the confluent workloads
echo "Creating the namespace for the confluent workloads"
kubectl create namespace confluent

# Setup the CFK Operator 
echo "Installing the CFK Operator"
helm repo add confluentinc https://packages.confluent.io/helm
helm repo update
helm upgrade --install confluent-operator confluentinc/confluent-for-kubernetes --namespace confluent   

helm install mssql-latest-deploy ./mssql-helm-chart/. --set ACCEPT_EULA.value=Y --set MSSQL_PID.value=Developer --set pvc.StorageClass=local-path 

kubectl apply -f ./crds/zookeeper.yaml
kubectl apply -f ./crds/kafka.yaml 
kubectl apply -f ./crds/kafkarest.yaml 
kubectl apply -f ./crds/schemaregistry.yaml
kubectl apply -f ./crds/connect.yaml
kubectl apply -f ./crds/controlcenter.yaml
kubectl apply -f ./crds/ingress.yaml # http://localhost:8080/

kubectl apply -f ./crds/dbz-connector.yaml   
 
kubectl apply -f ./crds/topic.yaml
kubectl apply -f ./crds/topic-testdb.yaml