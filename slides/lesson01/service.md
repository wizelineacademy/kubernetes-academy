---?color=var(--color-light-gray-2)
@title[Manifest files]

### Exposing applications with Services

---

Services allow to dynamically access a group of replica pods.

Pods can be created and destroyed for all kind of reasons. Instead of relying on Pod IP addresses which change, Kubernetes provides a Service which is an abstraction layer for communicating with pods. Communication to the Service will provide access to whatever replicas are up at the time.

---

@snap[north]

#### Service Types

@snapend

- **ClusterIP**: Exposes the Service on a cluster-internal IP. Choosing this value makes the Service only reachable from within the cluster. This is the default ServiceType.

- **NodePort**: Exposes the Service on each Node’s IP at a static port.

- **LoadBalancer**: Exposes the Service externally using a cloud provider’s load balancer.

---

@snap[north]

#### Create a new namespace to keep everything neat

@snapend

```sh
# We will use this namespace during this lesson
$ kubectl create namespace service-lesson
```

---

Before creating the service we first need some pods. We will use the previous deployment configuration.

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

---

@snap[north]

#### Apply deployment-nginx.yaml

@snapend

```sh
# Use the apply command to run a manifest file with the deployment
$ kubectl -n service-lesson apply -f deployment-nginx.yaml

# Verify your deployment is running
$ kubectl -n service-lesson get deployments

NAME            READY   UP-TO-DATE   AVAILABLE   AGE
my-deployment   3/3     3            3           11s
```

---

Now that we everything ready we will proceed with the creation of the service.

---

@snap[north]

#### lesson01/service-nginx.yaml

@snapend

```yaml
kind: Service
apiVersion: v1
metadata:
  name: my-service
spec:
  selector:
    app: nginx
  ports:
  - protocol: TCP
    port: 80
    targetPort: 80
  type: LoadBalancer
```

@[1](Service object)
@[6-7](Which pods make up the service)
@[12](Service type)

---

@snap[north]

#### Apply service-nginx.yaml

@snapend

```sh
# Use the apply command to run a manifest file with the service
$ kubectl -n service-lesson apply -f service-nginx.yaml

# Verify your service is running
$ kubectl get services --watch -n service-lesson

# Wait until you see an external IP address, once it's ready paste on your browser
NAME         TYPE           CLUSTER-IP   EXTERNAL-IP      PORT(S)        AGE
my-service   LoadBalancer   10.0.5.149   <pending>        80:31113/TCP   19s
my-service   LoadBalancer   10.0.5.149   35.232.227.252   80:31113/TCP   33s
```
