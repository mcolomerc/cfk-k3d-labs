# Schema Linking to Confluent Cloud

Export Schemas to Confluent Cloud using CFK SchemaExporter

1. Configure Credentials

- `ccloud-sr-credentials.txt`
- `password-encoder.txt`

2. Configure Schema Registry endpoint

- `./crds/schemaexporter.yaml`

3. Setup the K3d cluster

```sh
./cluster.sh
```

## Configure Number of Exporters

To allow for more than `10` exporters (the default maximum) to be created, you can set

```yaml
  configOverrides: 
    server:
      - exporter.max.exporters=20
```
