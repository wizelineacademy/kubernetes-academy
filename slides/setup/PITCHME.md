---?color=var(--color-light-gray-2)
@title[Setup your Kubernetes cluster]

## Setup

#### Local Kubernetes cluster with Vagrant

---

@title[Instructions]

#### Start the Kubernetes cluster with the following commands

```sh
# go inside the vagrant folder
$ cd vagrant-provisioning

# start the vagrant boxes (this may take a while)
$ vagrant up
```

---

@title[Validate]

#### Once the setup finishes:

```sh
# All boxes should have the status of 'running'
$ vagrant status

# SSH into the master node
$ vagrant ssh kmaster

# Check the status of the Kubernetes nodes
vagrant@kmaster:~$ kubectl get nodes
```
