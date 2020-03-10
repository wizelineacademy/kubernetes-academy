---?color=var(--color-light-gray-2)
@title[Manifest files]

### Exposing applications with Services

---

Services allow to dynamically access a group of replica pods. 

Pods can be created and destroyed for all kind of reasons. Instead of relying on Pod IP addresses which change, Kubernetes provides a Service which is an abstraction layer for communicating with pods. Communication to the Service will provide access to whatever replicas are up at the time. 

---

@snap[north]

#### Create a new namespace to keep everything neat

@snapend

```sh
# We will use this namespace during this lesson
$ kubectl create namespace service-lesson
```

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
    nodePort: 30080
  type: NodePort
```

@[1](Service object)
@[6-7](Which pods make up the service)
@[13](Service type)

---

@snap[north]

#### Apply service-nginx.yaml

@snapend

```sh
# Use the apply command to run a manifest file with the service
$ kubectl -n service-lesson apply -f service-nginx.yaml

# Verify your service is running
$ kubectl -n service-lesson get service
```

---
