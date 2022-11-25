# CFK Topics to Confluent Cloud

Setup the K3d cluster

```sh
./cluster.sh
```

## Credentials

The script will deploy the Kubernetes secret with the `bearer.txt` that contains Confluent Cloud credentials.

## Topic

The script will deploy the Topic `topic-from-cfk` defined at `crds/topic.yaml`

The Topic CRD references the Confluent Cloud cluster and the defined secret with credentials.

```yml
 kafkaRest:
    endpoint: <CCLOUD_API_REST_ENDPOINT> 
    kafkaClusterID: <CCLOUD_CLUSTER_ID>
    authentication:
      type: bearer
      bearer:
        secretRef: ccloud-credentials
```

### Describe Topic

```sh
kubectl describe topic topic-from-cfk -n confluent
```

# Clean 

```sh
./cleanup.sh    
```
