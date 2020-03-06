---?color=var(--color-light-gray-2)
@title[Namespaces]

### Namespaces

---

Namespaces allow you to "partition" your physical cluster into multiple virtual clusters to keep your objects organized.

---

![K8s Namespaces](slides/lesson01/images/k8s-ns.png)

---

@snap[north]

#### Create your first namespace

@snapend

```sh
# Create a namespace with the name mynamespace
$ kubectl create namespace mynamespace

# List namespaces
$ kubectl get namespaces
```

---

@snap[north]

#### Run an app within your new namespace

@snapend

```sh
# The --namespace flag indicates the namespace to use
$ kubectl --namespace mynamespace run nginx --image nginx

# Also you can use the shorter option -n for namespace
$ kubectl -n mynamespace get pods

# Want to list all pods across all namespaces?
$ kubectl get pods --all-namespaces
```

---

@snap[north]

#### Delete the namespace

@snapend

```sh
# Deleting the namespace also removes all objects within
$ kubectl delete namespace mynamespace
```
