# Confluent Connect (CFK) to Confluent Cloud

Setup the K3d cluster

```sh
./cluster.sh
```

* Script will deploy Connect: <https://docs.confluent.io/operator/current/co-configure-connect.html>

```sh
kubectl get connect -n confluent 
NAME      REPLICAS   READY   STATUS         AGE
connect   2                  PROVISIONING   86s
```

* Create Topic
  
```sh
confluent environment use <CCLOUD_ENV_ID>
confluent kafka cluster use <CCLOUD_CLUSTER_ID>
confluent kafka topic create pageviews_sr
```

Deploy the connector:

```yaml
  configs: 
    kafka.topic: "pageviews_sr" 
    key.converter: "org.apache.kafka.connect.storage.StringConverter"
    value.converter: "io.confluent.connect.avro.AvroConverter" 
    value.converter.schemas.enable: "true"
    value.converter.schema.registry.url: <SR_URL>
    value.converter.schema.registry.basic.auth.user.info: <SR_APP_KEY:SR_APP_SECRET>
    value.converter.schema.registry.basic.auth.credentials.source: USER_INFO
    max.interval: "100"
    iterations: "10000000"
    schema.string: "{\"type\": \"record\", \"namespace\": \"datagen\", \"name\": \"pageviews\", \"fields\": [{\"type\": {\"type\": \"long\", \"format_as_time\": \"unix_long\", \"arg.properties\": {\"iteration\": {\"start\": 1, \"step\": 10}}}, \"name\": \"viewtime\"}, {\"type\": {\"type\": \"string\", \"arg.properties\": {\"regex\": \"User_[1-9]{0,1}\"}}, \"name\": \"userid\"}, {\"type\": {\"type\": \"string\", \"arg.properties\": {\"regex\": \"Page_[1-9][0-9]?\"}}, \"name\": \"pageid\"}]}"
    schema.keyfield: "pageid"
```

```sh
kubectl apply -f ./crds/connector_sr.yaml
```

```sh
kubectl get connector -n confluent

NAME          STATUS    CONNECTORSTATUS   TASKS-READY   AGE
pageviewssr   CREATED   RUNNING           2/2           37s
```

* Clean up

```sh
./cleanup.sh    
```

## Prometheus & Grafana

### Grafana

Get your 'admin' user password:

`kubectl get secret --namespace default grafana -o jsonpath="{.data.admin-password}" | base64 --decode`

Use [http://localhost:8080](http://localhost:8080) for Grafana Web.

###  Grafana Troubleshooting

* Prometheus Datasource: It should be created on deployment, if not add the Datasource manually http://prometheus-server
* Kafka Connect Dashboard:  It should be created on deployment, if not Import `grafana/connect-dashboard.json`

### Prometheus

There is no Ingress rules for Prometheus, if you need to access the Prometheus Web:

`kubectl port-forward --namespace default svc/prometheus-server 9090:80`

Then use [http://localhost:9090/](http://localhost:9090/)
 
## Connect REST API

`kubectl port-forward --namespace confluent svc/connect-0-internal 9091:8083`

Then --> http://localhost:9091/connectors