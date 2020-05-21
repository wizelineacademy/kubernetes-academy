# Table of contents

* **[Preparation](#preparation)**
* **[First steps](#first-steps)**
* **[Namespaces](#namespaces)**
  * **[Your own namespace](#important-create-your-own-namespace)**
* **[Pods](#pods)**
* **[ReplicaSets](#replicasets)**
* **[Deployments](#deployments)**
* **[Services](#services)**
* **[Labels](#labels)**
* **[Clean up](#clean-up)**

# Preparation

1. Visit the GCP Console using an **incognito window** by going to
https://console.cloud.google.com/kubernetes/list?folder=&organizationId=&project=wizeline-academy-k8s-36bd66a7
2. Log in using the *Google Account* that you provided on the Wizeline
Academy registration form.
3. Click on the *Connect* button that appears besides the
`gke-academy-1` cluster.
4. Next hit the *Run in Cloud Shell* button to get the command that
connects to the K8s Cluster.
5. Hit enter on the `gcloud` command to execute it.
6. Send the *Cloud Shell* to a new window by hitting the button with
the little arrow.
7. Open the *Cloud Shell Editor* by clicking on the little pencil icon,
we'll use the editor to create the YAML files.

# First steps

## Inspecting the Cluster

```bash
kubectl get componentstatuses

kubectl get nodes
```

# Namespaces

## IMPORTANT: Create your own namespace.

The format suggested to use for the namespace name is
`firstName-lastName`, i.e juan-perez.

```bash
# Create your own namespace
kubectl create namespace <firstName-lastName>

# IMPORTANT: Set the namespace in the current context
kubectl config set-context --current --namespace=<firstName-lastName>
```

## Namespaces explained

```bash
# List the namespaces
kubectl get namespaces
```

The students will see all the namespaces from the other participants.
The resources each participant create will be created
inside their own namespace, collisions will not happen
no matter if their resources are named the same.

One common example about how namespaces are used in real
world scenarios is to separate application environments, like
`development` and `production`.

# Pods

## Create the Pod manifest file

Google Cloud Shell Editor can be used to easily create the file.

```yaml
# Using the Google Cloud Shell Editor
# Create the file nginx-pod.yaml
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
# Create the pod using the manifest file
kubectl create -f nginx-pod.yaml

# List pods
kubectl get pods

# See the pod's detailed information
kubectl describe pod nginx-pod

# Delete the pod
kubectl delete pod nginx-pod
```

# ReplicaSets

## Create the ReplicaSet manifest file

Google Cloud Shell Editor can be used to easily create the file.

```yaml
# Using the Google Cloud Shell Editor
# Create the file nginx-rs.yaml
apiVersion: apps/v1
kind: ReplicaSet
metadata:
  name: nginx-rs
  labels:
    app: nginx
    tier: frontend
spec:
  replicas: 1
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

The idea with this exercise is to understand how the only purpose of
replicasets is to maintain a fixed number of pods running, changes to
the replicaset are not immediately reflected on the running pods.

```bash
# Create the ReplicaSet
kubectl create -f nginx-rs.yaml

# List the ReplicaSets
kubectl get replicasets

# List the pods from the replica set
kubectl get pods -l tier=frontend

# Scale the number of pods
kubectl scale rs nginx-rs --replicas=3

# List the pods from the replica set
kubectl get pods -l tier=frontend

# Update the ReplicaSet Image
kubectl set image rs nginx-rs app=nginx:latest

# Describe the replica set
# And notice how the container image has been updated
kubectl describe rs nginx-rs

# List the pods from the replica set
# Notice how the pods weren't restarted
kubectl get pods -l tier=frontend

# Describe one of the pods
# Notice how it is using the old image
kubectl describe pod nginx-rs-<hash>

# Delete the pod
# A new pod will be created
kubectl delete pod nginx-rs-<hash>

# List the pods from the replica set
# Notice how we have a new pod
kubectl get pods -l tier=frontend

# Describe the new pod
# Notice how it is using the new image
kubectl describe pod nginx-rs-<hash>

# The old pods will keep using the old image

# Delete the replicaset
kubectl delete rs nginx-rs
```

# Deployments

## Create the Deployment manifest file

Google Cloud Shell Editor can be used to easily create the file.

```yaml
# Using the Google Cloud Shell Editor
# Create the file nginx-deployment.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-deployment
spec:
  replicas: 1
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

The idea of this excercise is to showcase how changes to the deployment
definition are immediately applied to its pods, and that replicasets
are used to accomplish that.

```bash
# Create a Deployment
kubectl create -f nginx-deployment.yaml

# List the deployments
kubectl get deployments

# See the pods deployed
kubectl get pods -l app=nginx

# List the replica sets
kubectl get replicasets

# Scale up the deployment
kubectl scale deployment nginx-deployment --replicas=3

# See the pods deployed
kubectl get pods -l app=nginx

# List the replica sets
kubectl get replicasets

# Rollout a new version
kubectl set image deployment nginx-deployment app=nginx:latest

# Inspect the pods
kubectl get pods -l app=nginx

# List the replicasets
# Notice how now we have a new replicaset
kubectl get replicasets

# Restore the old version
kubectl rollout undo deployment nginx-deployment

# List the replicasets
# Notice how now the deployment uses the old replicaset
kubectl get replicasets

# Do not delete the deployment, we'll use it next.
```

# Services

## Create the Service manifest file

Google Cloud Shell Editor can be used to easily create the file.

```yaml
# Using the Google Cloud Shell Editor
# Create the file nginx-service.yaml
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
kubectl create -f nginx-service.yaml

# The above command will create a service
# Take note of the random port it's using
kubectl get services

# Get pods with their IPs
kubectl get pods -l app=nginx -o wide

# Get the service endpoints
# Notice how the IPs match
kubectl get endpoints nginx-service

# The reason is that the service uses a label selector
# that matches the pods from the already existent deployment

# The service is exposed on a random port on the nodes
# Get the IP from any of the nodes
kubectl get nodes -o wide

# Once ready you can visit your app
curl http://<NODE-EXTERNAL-IP>:<RANDOM-PORT>

# Nginx should greet :)

# Delete the service
kubectl delete service nginx-service
```

# Labels

## Create the Pod manifest file

Google Cloud Shell Editor can be used to easily create the file.

Pod manifest file in which we put two labels:
* env: development
* owner: `<your-name>`

Labels can be used to organize and to select subsets of objects.
Labels are used on ReplicaSets, Deployments, Services and other
resources.

```yaml
# Using the Google Cloud Shell Editor
# Create the file nginx-labels.yaml
apiVersion: v1
kind: Pod
metadata:
  name: nginx-labels
  labels:
    env: development
    # Replace this with your name.
    owner: <your-name>
spec:
  containers:
  - name: nginx
    image: nginx:latest
```

```bash
# Create the Pod using the manifest file
kubectl create -f nginx-labels.yaml

# Show the pods labels
kubectl get pods --show-labels

# Add a new label to the pod
kubectl label pods nginx-labels app=nginx-labels

# Show the pods labels
kubectl get pods --show-labels

# To use a label for filtering we can use the --selector option
kubectl get pods --selector env=development

# The --selector option can be abbreviated to -l
kubectl get pods -l owner=<your-name>

# List all pods that are either labelled with env=development
# or with env=production
kubectl get pods -l 'env in (production, development)'

# Other verbs also support label selection, like delete
kubectl delete pods -l 'env in (production, development)'
```

# Clean up

Type `exit` on your *Cloud Shell* session.

Close your incognito browser window.