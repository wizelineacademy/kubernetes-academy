# Preparation

1. Visit the GCP Console by following [this link](https://console.cloud.google.com/kubernetes/list?folder=&organizationId=&project=wizeline-academy-k8s-36bd66a7).
2. Log in using the Google Account that you provided on the Wizeline Academy registration form.
3. Open the Google Cloud Shell.

# Connecting to a GKE Cluster

```bash
$ gcloud container clusters get-credentials gke-academy-1 --region=us-central1
$ gcloud container clusters list --region=us-central1
```

# Inspecting the Cluster

```bash
$ kubectl get componentstatuses
$ kubectl get nodes
```

# Pods

```bash
# Create a single pod
$ kubectl run --generator=run-pod/v1 nginx-pod --image=nginx:latest

# List the pods
$ kubectl get pods

# Describe your pod
$ kubectl describe pod nginx-pod

# Delete the pod
$ kubectl delete pod nginx-pod
```

## Create a Pod using a manifest file

```yaml
# Save this to a file named nginx-pod.yaml
# If using Vim type ":set paste" before pasting this
apiVersion: v1
kind: Pod
metadata:
  name: nginx-pod
spec:
  containers:
  - name: nginx
    image: nginx:latest
```

```bash
# Create a pod using the manifest file
$ kubectl create -f nginx-pod.yaml

# List pods with detailed information
$ kubectl get pods -o wide

# Delete the pod
$ kubectl delete pod nginx-pod
```

# ReplicaSets

```yaml
# ReplicaSet manifest file nginx-rs.yaml
# If using Vim type ":set paste" before pasting this
apiVersion: apps/v1
kind: ReplicaSet
metadata:
  name: nginx-rs
  labels:
    app: nginx
    tier: frontend
spec:
  replicas: 3
  selector:
    matchLabels:
      tier: frontend
  template:
    metadata:
      labels:
        tier: frontend
    spec:
      containers:
      - name: app
        image: nginx:1.7
```

```bash
# Create a new ReplicaSet
$ kubectl apply -f nginx-rs.yaml

# List the ReplicaSets
$ kubectl get replicasets

# List the pods from the replica set
$ kubectl get pods -l tier=frontend

# Scale the number of pods
$ kubectl scale rs/nginx-rs --replicas=5

# List the pods from the replica set
$ kubectl get pods -l tier=frontend

# Update the ReplicaSet Image
$ kubectl set image rs/nginx-rs app=nginx:latest

# Describe the replica set
# And notice how the container image has been updated
$ kubectl describe rs nginx-rs

# List the pods from the replica set
# Notice how the pods weren't restarted
$ kubectl get pods -l tier=frontend

# Describe one of the pods
# Notice how it is using the old image
$ kubectl describe pod nginx-rs-<hash>

# Delete the pod
# A new pod will be created
$ kubectl delete pod nginx-rs-<hash>

# List the pods from the replica set
# Notice how we have a new pod
$ kubectl get pods -l tier=frontend

# Describe the new pod
# Notice how it is using the new image
$ kubectl describe pod nginx-rs-<hash>

# The old pods will keep using the old image

# Delete the replicaset
$ kubectl delete rs nginx-rs
```

# Deployments

```yaml
# Deployment manifest file nginx-deployment.yaml
# If using Vim type ":set paste" before pasting this
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-deployment
spec:
  replicas: 3
  selector:
    matchLabels:
      app: nginx
  template:
    metadata:
      name: nginx
      labels:
        app: nginx
    spec:
      containers:
      - image: nginx:1.7
        name: app
```

```bash
# Create a Deployment
$ kubectl create -f nginx-deployment.yaml --record

# List the deployments
$ kubectl get deployments

# See the pods deployed
$ kubectl get pods -l app=nginx

# List the replica sets
$ kubectl get replicasets

# Scale up the deployment
$ kubectl scale deployment nginx-deployment --replicas=5

# See the pods deployed
$ kubectl get pods -l app=nginx

# List the replica sets
$ kubectl get replicasets

# Rollout a new version
$ kubectl set image deployment nginx-deployment app=nginx:latest --record

# Inspect the pods
$ kubectl get pods -l app=nginx

# List the replicasets
$ kubectl get replicasets

# Restore the old version
$ kubectl rollout undo deployment nginx-deployment

# List the replicasets
$ kubectl get replicasets

# See the deployment history
$ kubectl rollout history deployment nginx-deployment
```

# Services

```bash
# List services
$ kubectl get services

# Expose the deployment to the internet
$ kubectl expose deployment nginx-deployment --port=80 --target-port=80 --type=NodePort

# The above command will create a service
# Take note of the random port it's using
$ kubectl get services

# The service is exposed on a random port on the nodes
# Get one of the nodes IP
$ kubectl get nodes -o wide

# Once ready you can visit http://<NODE-EXTERNAL-IP>:<RANDOM-PORT>
# Inspect the Headers

# Delete the service
$ kubectl delete service nginx-deployment
```

## Using a manifest to create the service

```yaml
# Service manifest file nginx-service.yaml
# If using Vim type ":set paste" before pasting this
apiVersion: v1
kind: Service
metadata:
  name: nginx-service
spec:
  type: NodePort
  selector:
    app: nginx
  ports:
    - protocol: TCP
      port: 80
      targetPort: 80
```

```bash
# Create the NodePort service
$ kubectl apply -f nginx-service.yaml

# The above command will create a service
# Take note of the random port it's using
$ kubectl get services

# The service is exposed on a random port on the nodes
# Get one of the nodes IP
$ kubectl get nodes -o wide

# Once ready you can visit http://<NODE-EXTERNAL-IP>:<RANDOM-PORT>
# Inspect the Headers

# Delete the service
$ kubectl delete service nginx-service
```

# Namespaces

```bash
$ kubectl get namespaces

$ kubectl create namespace my-namespace

$ kubectl run --generator=run-pod/v1 nginx --image=nginx:latest -n my-namespace
```

```yaml
# Namespace manifest file nginx-namespace-dev.yaml
# If using Vim type ":set paste" before pasting this
apiVersion: v1
kind: Namespace
metadata:
  name: development
  labels:
    name: development
```

```yaml
# Namespace manifest file nginx-namespace-prod.yaml
# If using Vim type ":set paste" before pasting this
apiVersion: v1
kind: Namespace
metadata:
  name: production
  labels:
    name: production
```

```bash
# List namespaces
$ kubectl get namespaces

# List namespaces and their labels
$ kubectl get namespaces --show-labels

# Create a pod in namespace 'dev'
kubectl run --generator=run-pod/v1 nginx-pod-dev --image=nginx:latest --namespace=dev

# Get pods in the namespace 'dev'
kubectl get pods -n dev

# Delete a pod located in a specific namespace
kubectl delete pod -n your-namespace 
```

# Labels

```yaml
# Pod manifest file nginx-pod-2.yaml in which we put two labels
# If using Vim type ":set paste" before pasting this
apiVersion: v1
kind: Pod
metadata:
  name: nginx-pod-2
  labels:
    env: development
    owner: your-name
spec:
  containers:
  - name: nginx
    image: nginx:latest
    ports:
    - containerPort: 8081
```

```bash
# Show the pods labels
kubectl get pods --show-labels

# Add a label to the pod
kubectl label pods pod-name owner=your-name

# To use a label for filtering we can use the --selector option
kubectl get pods --selector owner=your-name

# The --selector option can be abbreviated to -l
kubectl get pods -l owner=your-name

# List all pods that are either labelled with env=development or with env=production
kubectl get pods -l 'env in (production, development)'

# Other verbs also support label selection, like delete
kubectl delete pods -l 'env in (production, development)'
```