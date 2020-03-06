---?color=var(--color-light-gray-2)
@title[Manifest files]

### Managing Deployments

---

A Deployment provides declarative updates for Pods and ReplicaSets.

A ReplicaSet’s purpose is to maintain a stable set of replica Pods running at any given time. As such, it is often used to guarantee the availability of a specified number of identical Pods.

---

@snap[north]

#### Create a new namespace to keep everything neat

@snapend

```sh
# We will use this namespace during this lesson
$ kubectl create namespace deployment-lesson
```

---

@snap[north]

#### lesson01/deployment-nginx.yaml

@snapend

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: my-deployment
spec:
  template:
    metadata:
      name: my-nginx
      labels:
        app: nginx
    spec:
      containers:
        - name: nginx
          image: "nginx:latest"
  replicas: 3
  selector:
    matchLabels:
      app: nginx
```

@[2](Deployment object)
@[6-14](Pod definition)
@[15](Number of managed pods)
@[16-18](Pods with these labels will be owned by this deployment)

---

@snap[north]

#### Apply deployment-nginx.yaml

@snapend

```sh
# Use the apply command to run a manifest file with the deployment
$ kubectl -n deployment-lesson apply -f deployment-nginx.yaml

# Verify your deployment is running
$ kubectl -n deployment-lesson get deployments
```

---

@snap[north]

#### All objects

@snapend

```sh
# All objects in the namespace
$ kubectl -n deployment-lesson get all
```

---

@snap[north]

#### All objects (output)

@snapend

```
NAME                                 READY   STATUS    RESTARTS   AGE
pod/my-deployment-5bc7cbbc6c-5b2h9   1/1     Running   0          6s
pod/my-deployment-5bc7cbbc6c-9qmln   1/1     Running   0          6s
pod/my-deployment-5bc7cbbc6c-sclpp   1/1     Running   0          6s

NAME                            DESIRED   CURRENT   UP-TO-DATE   AVAILABLE   AGE
deployment.apps/my-deployment   3         3         3            3           6s

NAME                                       DESIRED   CURRENT   READY   AGE
replicaset.apps/my-deployment-5bc7cbbc6c   3         3         3       6s
```

@[6-7](The deployment we created)
@[9-10](ReplicaSet is in charge of the lifecycle of the pods)
@[1-4](3 managed pods running)
