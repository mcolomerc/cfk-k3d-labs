# Policy as Code with CFK and Kyverno

Setup the K3d cluster

```sh
./cluster.sh
```

The script will create a K3d cluster and will deploy:  

* [Kyverno](https://kyverno.io/) Kubernetes Native Policy Management

* [Confluent For Kubernetes](https://docs.confluent.io/operator/current/overview.html) - Zookeeper, Kafka and Schema Registry

* A Kyverno rule for the maximum number of partitions (5) allowed for a `KafkaTopic` resource.

```sh
kubectl get clusterpolicy     
NAME                      BACKGROUND   VALIDATE ACTION   READY
topic-number-partitions   true         enforce           true
```

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
Error from server: error when creating "./topics/invalid-topic.yaml": admission webhook "validate.kyverno.svc-fail" denied the request: 

policy KafkaTopic/confluent/invalid-topic for resource violation: 

topic-number-partitions:
  topic-number-partitions: 'validation error: The number of partitions for a Topic
    can not be greater than 5!. rule topic-number-partitions failed at path /spec/partitionCount/'
```

## Clean

```sh
./cleanup.sh    
```
