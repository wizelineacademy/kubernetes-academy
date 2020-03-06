---?color=var(--color-light-gray-2)
@title[Manifest files]

### Managing Pods

---

Pods are the smallest deployable units of computing that can be created and managed in Kubernetes.

---

@snap[north]

#### Create a new namespace to keep everything neat

@snapend

```sh
# We will use this namespace during this lesson
$ kubectl create namespace pod-lesson
```

---

@snap[north]

#### lesson01/pod-nginx.yaml

@snapend

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: my-nginx
  labels:
    app: my-app
    type: server
spec:
  containers:
    - name: nginx
      image: "nginx:latest"
```

@[2](Pod object)
@[4](Name of the pod)
@[5-7](Labels to identify this pod later)
@[10-11](Details of the container to run)

---

@snap[north]

#### Apply pod-nginx.yaml file

@snapend

```sh
# Use the apply command to run a manifest file
$ kubectl -n pod-lesson apply -f pod-nginx.yaml

# Verify your pod is running
$ kubectl -n pod-lesson get pods

# Get more details of your pod
$ kubectl -n pod-lesson describe pod my-nginx
```

---

@snap[north]

#### Port forwarding

@snapend

```sh
# Port forwarding from container (80) to host machine (8080)
$ kubectl -n pod-lesson port-forward my-nginx 8080:80

# Leave the above command running, while in another terminal:

# Curl to see the HTML of nginx
$ curl localhost:8080

# Stop the port forwarding process with ctrl-c
```

---

@snap[north]

#### Delete a pod

@snapend

```sh
# You can delete a pod using the manifest file:
$ kubectl -n pod-lesson delete -f pod-nginx.yaml

# or

# Using the kubectl delete command:
$ kubectl -n pod-lesson delete pod my-nginx
```

---

@snap[north]

#### lesson01/pod-redis.yaml

@snapend

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: my-redis
  labels:
    app: my-app
    type: cache
spec:
  containers:
    - name: redis
      image: "redis:latest"
      ports:
        - containerPort: 6379
          protocol: TCP
```

@[11](We use the redis:latest docker image)
@[12-14](List of ports to expose from the container)
@[12-14](Not specifying a port here DOES NOT prevent that port from being exposed)

---

@snap[north]

#### Apply pod-redis.yaml file

@snapend

```sh
# Use the apply command to run a manifest file
$ kubectl -n pod-lesson apply -f pod-redis.yaml

# Verify your pod is running
$ kubectl -n pod-lesson get pods
```

---

@snap[north]

#### Interacting with Pod's logs

@snapend

```sh
# See the logs of the Redis container with the following command
$ kubectl -n pod-lesson logs my-redis

# If you want to follow the logs use the -f flag, exit with ctrl-c
$ kubectl -n pod-lesson logs -f my-redis
```

---

@snap[north]

#### Cleaning up namespace

@snapend

```sh
# Delete the pod-lesson namespace
$ kubectl delete namespace pod-lesson
```
