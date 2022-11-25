# Confluent Schemas (CFK) to Confluent Cloud

Deploy and manage Confluent Cloud schemas with Confluent For Kubernetes

Setup the K3d cluster

```sh
./cluster.sh
```

## Confluent Cloud Schema Registry credentials

`kubectl -n confluent create secret generic ccloud-sr-credentials --from-file=basic.txt=ccloud-sr-credentials.txt`

Where ccloud-sr-credentials.txt:

```txt
username=<CCLOUD_SR_API_KEY>
password=<CCLOUD_SR_API_SECRET>
```

## Deploy

Define a ConfigMap with the Schema definition.

### Schema Config

```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: schema-config
  namespace: confluent
data:
  schema: |
    {
      "namespace": "io.confluent.examples.clients.basicavro",
      "type": "record",
      "name": "Payment",
      "fields": [
        {"name": "id", "type": "string"},
        {"name": "amount", "type": "double"},
        {"name": "email", "type": "string"}
      ]
    }
```

### Schema

Define the Schema Registry endpoint and the reference to the Secret with the Schema Registry credentials

```yaml
apiVersion: platform.confluent.io/v1bet
kind: Schema
metadata:
  name: payment-value
  namespace: confluent
spec:
  data:
    configRef: schema-config
    format: avro
  schemaRegistryRest:
    endpoint:  <CCLOUD_SR_ENDPOINT>    
    authentication:
      type: basic                  
      basic:
        secretRef: ccloud-sr-credentials   
```


## Get Schema

`kubectl get schema -n confluent`

```sh
NAME            FORMAT   ID       VERSION   STATUS   AGE
payment-value   avro     100064   1                  2m31s
```

Get schema version

`kubectl get schema payment-value -ojsonpath="{.status.version}" -n confluent`

```sh
1
```

* Clean up

```sh
./cleanup.sh    
```