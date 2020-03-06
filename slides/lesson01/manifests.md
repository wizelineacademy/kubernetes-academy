---?color=var(--color-light-gray-2)
@title[Manifest files]

### Manifest files

---

YAML or JSON files that describe Kubernetes objects and its attributes. You pass these files to Kubernetes in order to update the current status of the cluster to match your definition.

---

@snap[north]

#### Example of a manifest file

@snapend

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: my-pod
spec:
  containers:
    - name: nginx
      image: "nginx:latest"
```

---

@snap[north]

#### Fields of a manifest file

@snapend

- **apiVersion**: Which version of the Kubernetes API you’re using to create this object

- **kind**: What kind of object you want to create

- **metadata**: Data that helps uniquely identify the object, including a name string, UID, and optional namespace

- **spec**: What state you desire for the object
