---?color=var(--color-light-gray-2)
@title[kubectl]

### kubectl

Kubectl is a command line tool for controlling Kubernetes clusters.
`kubectl` looks for a file named `config` in the `$HOME/.kube` directory.
You can specify other `kubeconfig` files by setting the `KUBECONFIG`
environment variable or by setting the `--kubeconfig` flag.

---

@snap[north]
#### Connect to a GKE Cluster
@snapend

```sh
# updates a kubeconfig file with appropriate credentials and endpoint information
gcloud container clusters get-credentials CLUSTER-NAME
```

---

@snap[north]
#### Interact with the cluster
@snapend

```sh
# list your nodes
kubectl get nodes

# get more details
kubectl describe nodes
```

@[2](List your nodes)
@[5](Describe your nodes)

---

@snap[north]
#### Create some resources
@snapend

```sh
# create a dummy namespace
kubectl create namespace dummy

kubectl get namespaces

# run (deploy) an nginx container inside the dummy namespace
kubectl -n dummy run my-nginx --image=nginx

# list the pods deployed
kubectl -n dummy get pods
```

@[2](Create a namespace)
@[4](List your namespaces)
@[7](Run an image)
@[10](List your pods)

---

@snap[north]
#### Interact with your deployment
@snapend

```sh
# port-forward the nginx port to the local computer
kubectl -n dummy port-forward deployment/my-nginx 8888:80

# now you can browse to http://localhost:8888
```

@[2](Port forward)
@[4](Browse)

---

@snap[north]
#### Cleanup
@snapend

```sh
# delete your deployment
kubectl -n dummy delete deployment my-nginx

# delete your namespace
kubectl delete namespace dummy
```

@[2](Delete your deployment)
@[5](Delete the namespace)
