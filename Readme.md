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
  
--- 

[CFK Examples](https://github.com/confluentinc/confluent-kubernetes-examples)