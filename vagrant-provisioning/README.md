
*Note:* The work on this repository is based on Exxactcorp's [k8s_ubuntu](https://bitbucket.org/exxsyseng/k8s_ubuntu/src/master/).

# Bringing up the Kubernetes Cluster

To create and configure our Kubernetes cluster run the Vagrant command with the up flag. The binary will read the Vagrantfile and bring up the Kubernetes cluster.

```bash
$ vagrant up
```

# Checking the Status

```bash
$ vagrant status
```

# Logging into the Master

```bash
$ vagrant ssh kmaster
```

# Getting the list of Nodes

```bash
vagrant@kmaster $ kubectl get nodes
```

# Destroy the Environment

```bash
$ vagrant destroy
```