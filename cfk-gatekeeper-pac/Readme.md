# Policy as Code with CFK and Gatekeeper

Setup the K3d cluster

```sh
./cluster.sh
```

The script will create a K3d cluster and will deploy:  

* [Gatekeeper](https://kubernetes.io/blog/2019/08/06/opa-gatekeeper-policy-and-governance-for-kubernetes/) Kubernetes OPA Gatekeeper

* [Confluent For Kubernetes](https://docs.confluent.io/operator/current/overview.html) - Zookeeper, Kafka and Schema Registry

* A OPA rule for the maximum number of partitions (5) allowed for a `KafkaTopic` resource.

## Topics

* Create a Topic with `partitionCount: 1`

```sh
kubectl apply -f ./topics/valid-topic.yaml
```

```sh
kubectl get topic -n confluent         
NAME          REPLICAS   PARTITION   STATUS    CLUSTERID                AGE
valid-topic   1          1           CREATED   Gcp3tTPhRF-suuldcu8R3w   22m
```

* Create a Topic with `partitionCount: 15`

```sh
kubectl apply -f ./topics/invalid-topic.yaml
```

Output:

```sh
Error from server (Forbidden): error when creating "./topics/invalid-topic.yaml": admission webhook "validation.gatekeeper.sh" denied the request: [topic-partitions-constraint] KafkaTopic partitionCount must be less than the maximum allowed number of partitions (set via the 'maxPartitions' parameter).
```

## Clean

```sh
./cleanup.sh    
```
