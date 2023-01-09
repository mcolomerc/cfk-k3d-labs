# CFK examples with K3D - local cluster(s)

- [Confluent For Kubernetes](https://docs.confluent.io/operator/2.0.0/overview.html) (CFK)

- [k3d](http://k3d.io) is a lightweight wrapper to run k3s (Rancher Lab's minimal Kubernetes distribution) in Docker.
  
- [kubectl](https://kubernetes.io/docs/reference/kubectl/kubectl/): The Kubernetes command-line tool.

- [Helm](https://helm.sh/): manage Kubernetes applications.

---

## LABS

- [POD Scheduling](cfk-pod-sch/Readme.md)

  - One Replica per Node
  - Taints and Tolerations
  - Pod Affinity & Anti-affinity

- [Cluster Linking](cfk-cluster-link/Readme.md)
  
  - Source and Destination cluster
  - Connect (Datagen source connector)
  - Consumer app

- [Connect to Confluent Cloud](cfk-connect-to-ccloud/Readme.md)
  
  - Connect
  - Connector (Datagen source connector) + Avro

- [Schemas to Confluent Cloud](cfk-schemas-to-ccloud/Readme.md)
  
  - Manage and Deploy Schemas to Confluent Cloud Schema Registry.

- [Topics to Confluent Cloud](cfk-topics-to-ccloud/Readme.md)
  
  - Manage and Deploy Topics to Confluent Cloud.

- [Schema Link to Confluent Cloud](cfk-schema-link-to-ccloud/Readme.md)
  
  - Manage Schema Registry exporters to Confluent Cloud.

- [Policy as Code with CFK and Kyverno](cfk-kyverno-pac/Readme.md)
  
  - Enforce policy rules. Example with maximum number of partitions for a `KafkaTopic`.

- [Policy as Code with CFK and Gatekeeper](cfk-gatekeeper-pac/Readme.md)
  
  - Enforce policy rules. Example with maximum number of partitions for a `KafkaTopic`.
  
- [SQL Server + Debezium + Connect](cfk-connect-dbz/Readme.md)
  
  - SQL Server CDC with Debezium connector.
   
---

[CFK Examples](https://github.com/confluentinc/confluent-kubernetes-examples)