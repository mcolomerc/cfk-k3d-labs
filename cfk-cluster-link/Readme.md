# CFK - Cluster Linking Demo

1. Registry
2. k3d cluster
3. Confluent operator (Helm)
4. Confluent Cluster (Source)
   1. Connect
   2. Topic (pageviews)
   3. Source Connector (pageviews)
5. Confluent Cluster (Destination)
6. Consumer App (Destination)

## Setup

1. Registry
2. k3d cluster
3. Confluent operator (Helm)
4. Source: Confluent Cluster (namespace: source)
   1. Connect
   2. Topic (pageviews)
   3. Source Connector (pageviews)
5. Destination: Confluent Cluster (namespace: dest)
    1. Cluster Linking

```./start.sh```

## Consumer

Build and Deploy consumer App:

```./consumer/deploy.sh```

## CleanUp

```./cleanup.sh```