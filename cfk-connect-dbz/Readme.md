# Debezium Connector

SQL Server -> Connect -> Confluent Platform

- Confluent version used: `7.3.0`
- [Debezium Connector SQL Server](https://debezium.io/documentation/reference/stable/connectors/sqlserver.html): `1.9.7` 
- SQL Server: `2019-CU12`

## Setup the environment

Setup the K3d cluster: `./cluster.sh`

Components:

- SQL Server (mssql-helm-chart)
  
- Confluent Platform (Confluent For Kubernetes Operator)
  - Zookeeper
  - Kafka
  - Schema Registry
  - Connect
    - Debezium Connector
  - Control Center (with Ingress rule)

## SQL Server

Access the SQL Server instance:

- Port Forward: `kubectl port-forward --namespace default svc/mssql-latest-deploy $(kubectl get svc/mssql-latest-deploy -ojson | jq '.spec.ports[0].nodePort'):1433`

- Get the SQL Server password. MSSQL SA Password is configured at: `./mssql-helm-chart/values.yaml`
     
 The default deployment value used is:

```yaml 
  sa_password: "Toughpass1!"
```

- Connect to SQL Server:

  - Using database manager tool, like [DBeaver](https://dbeaver.io/): 
    - Host: `localhost`
    - Port: `31152`
    - Database/Schema: `master`
    - SQL Server Authentication
      - Username: `sa`
      - Password: `Toughpass1!`
  - Using JDBC: `jdbc:sqlserver://;serverName=localhost;port=31152;databaseName=master`
  - Using sqlcmd: `sqlcmd -S localhost,31152 -U sa -P Toughpass1!`

- Create schema, table, insert records and enable CDC: `sql/inventory.sql`

## Control Center

- Open Browser: `http://localhost:8080`

## Topics

- Schema changes: `schema-changes.inventory`
  
- Records: `testdb.dbo.customers`

## Deployment checks

- All pods: `kubectl get pod -A`

- Confluent Pods:
  
  - Source: `kubectl get pod -n confluent`

- Get Connector status:

   `kubectl get connector  -n confluent`

- Connector Logs:

 `kubectl logs connect-0 -n confluent`

- Connect REST API:
  
 `kubectl port-forward -n confluent connect-0 8083:8083`

 `http://localhost:8083/connectors/customers-connector`

## Consumer

Build and Deploy consumer App:

- `cd consumer`

- `./deploy.sh` *This will build the docker image and deploy the app to the destination cluster.*
*The Script only works from this folder*

Check the consumer logs:

`kubectl logs $(kubectl get pod --selector="app=consumer" --output jsonpath='{.items[0].metadata.name}')`

- Logs: 

    Example:

    ```json
    % Message on testDB.dbo.customers[0]@8:
    {"before":null,"after":{"id":1009,"first_name":"Anne_6","last_name":"Kretchmar_6","email":"annek_6@noanswer.org"},"source":{"version":"1.9.7.Final","connector":"sqlserver","name":"testDB","ts_ms":1673265491720,"snapshot":"false","db":"testDB","sequence":null,"schema":"dbo","table":"customers","change_lsn":"00000027:00000aa8:0003","commit_lsn":"00000027:00000aa8:0005","event_serial_no":1},"op":"c","ts_ms":1673265495734,"transaction":null}
    ```

## Clean

Clean: `./cleanup.sh`