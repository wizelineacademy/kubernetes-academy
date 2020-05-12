# Connecting to a GKE Cluster

```bash
$ gcloud config set compute/zone us-west1-a
$ gcloud container cluster create awesome-cluster
$ gcloud auth application-default login
```

# Inspecting the Cluster

```bash
$ kubectl get componentstatuses
$ kubectl get nodes
```

# PODS

```bash
$ kubectl get pods
$ kubectl get pods -o wide
```

## Run a single POD

```bash
cat << EOF | kubectl create -f -
apiVersion: v1
kind: Pod
metadata:
  name: nginx
spec:
  containers:
  - name: nginx
    image: nginx
EOF
```

# Deployments

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-deployment
spec:
  selector:
    matchLabels:
      app: nginx
  replicas: 2
  template:
    metadata:
      labels:
        app: nginx
    spec:
      containers:
      - name: nginx
        image: nginx:1.7.9
        ports:
        - containerPort: 80
```

```bash
$ kubectl create -f nginx-deployment.yaml --record
$ kubectl rollout status deployments nginx-deployment
$ kubectl get deployments
$ kubectl get pods -o wide

$ kubectl get replicasets
$ kubectl describe replicasets nginx-deployment-[hash]

$ kubectl scale deployment nginx-deployment --replicas=5

$ kubectl set image deployment nginx-deployment nginx=nginx:latest

$ kubectl rollout undo deployments nginx-deployment

$ kubectl rollout history deployment nginx-deployment
```

# Services

```yaml
apiVersion: v1
kind: Service
metadata:
  name: nginx-nodeport
spec:
  type: NodePort
  ports:
  - protocol: TCP
    port: 80
    targetPort: 80
    nodePort: 30080
  selector:
    app: nginx
```

