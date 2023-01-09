# Debezium Connector

SQL Server -> Connect -> Confluent Platform

Setup the K3d cluster: `./cluster.sh`

 - SQL Server (mssql-helm-chart)
 - Confluent Platform (Confluent For Kubernetes Operator)
   - Zookeeper
   - Kafka
   - Schema Registry
   - Connect
     - Debezium Connector
   - Control Center (with Ingress rule)

## SQL Server

Access the SQL Server - NodePort

* SQL Server - NodePort: `kubectl describe svc/mssql-latest-deploy | grep -i nodeport`

* Port Forward: `kubectl port-forward --namespace default svc/mssql-latest-deploy <node_port>:1433`

* Create schema, table, insert records and enable CDC: `sql/inventory.sql`

## Control Center

Open Browser: `http://localhost:8080`

## Topics

* Schema changes: `schema-changes.inventory`
  
* Records: `testDB.dbo.customers`

## Consumer

* Build and Deploy: `./consumer/deploy.sh`

* Logs:

    * Get Consumer POD name: `kubectl get pod`

    * Logs: `kubectl logs consumer-deployment-<id>`

    Example:

    ```json
    % Message on testDB.dbo.customers[0]@8:
    {"before":null,"after":{"id":1009,"first_name":"Anne_6","last_name":"Kretchmar_6","email":"annek_6@noanswer.org"},"source":{"version":"1.9.7.Final","connector":"sqlserver","name":"testDB","ts_ms":1673265491720,"snapshot":"false","db":"testDB","sequence":null,"schema":"dbo","table":"customers","change_lsn":"00000027:00000aa8:0003","commit_lsn":"00000027:00000aa8:0005","event_serial_no":1},"op":"c","ts_ms":1673265495734,"transaction":null}
    ```

## Clean

Clean: `./cleanup.sh`