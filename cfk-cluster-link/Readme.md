# CFK - Cluster Linking Demo

- *Source*: Confluent For Kubernetes cluster
- *Destination*: Confluent For Kubernetes cluster

## Versions

- Confluent version used: `7.3.0`

## Components

1. Registry
2. k3d cluster
3. Confluent operator (Helm)
4. Confluent Cluster (Source)
   1. Connect
   2. Topic (pageviews)
   3. Source Connector (pageviews)
5. Confluent Cluster (Destination)
   1. Cluster linking to mirror *pageviews* topic from source cluster
6. Consumer App (Destination)
   1. Consume pageviews topic and logs the messages

## Setup

Deployment script: `./start.sh`

1. Registry
2. k3d cluster
3. Confluent operator (Helm)
4. Source: Confluent Cluster (namespace: source)
   1. Connect
   2. Topic (pageviews)
   3. Source Connector (pageviews)
5. Destination: Confluent Cluster (namespace: dest)
    1. Cluster Linking 
6. Control Center to monitor both clusters (namespace: confluent)
   1. Ingress rule for Control Center access from localhost
 
## Deployment checks

- All pods: `kubectl get pod -A`

- Confluent Pods:
  
  - Source: `kubectl get pod -n source`
  
  - Destination: `kubectl get pod -n dest`

  - Control Center: `kubectl get pod -n confluent`

- Get Connector status:

   `kubectl get connector  -n source`  

- Describe the ClusterLinking:

   `kubectl get clusterlink cl-demo -oyaml -n dest`

   or just ClusterLinking status:

   `kubectl -n dest get clusterlink cl-demo -ojson | jq '.status.appState'`

- Get Topic details:

   `kubectl get topic pageviews -n source`

   *Topic on destination was created automatically by the ClusterLinking, so there is no CRD for it.*

## Consumer

Consumer application is a Golang Kafka consumer reading from the destination cluster.  

```go
bootstrapServers := "kafka.dest.svc.cluster.local:9092"
group := "dump-consumer"
topics := []string{"pageviews"}
```

Build and Deploy consumer App:

- `cd consumer`

- `./deploy.sh` *This will build the docker image and deploy the app to the destination cluster.*
*The Script only works from this folder* 

Check the consumer logs to see replicated messages:

`kubectl logs $(kubectl get pod --selector="app=consumer" --output jsonpath='{.items[0].metadata.name}')`

## Control Center

Control Center was deployed to monitor both clusters.

Control Center deployment:

`kubectl apply -f ./cfk/confluent/controlcenter.yaml`

Ingress rule:

`kubectl apply -f ./cfk/confluent/ingress.yaml`

Open browser and go to: `http://localhost:9900/clusters`


## CleanUp

```./cleanup.sh```