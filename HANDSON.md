# Table of contents

* **[Preparation](#preparation)**
* **[First steps](#first-steps)**
* **[Namespaces](#namespaces)**
  * **[Your own namespace](#important-create-your-own-namespace)**
* **[Persisting Data](#persisting-data)**

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

# Persisting Data

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


# Health Checks
.
.
.
.
.
.

# CronJob

* Encrypt MySQL password, for example: echo -n 'password' | base64

* Copy the output from the command above and save it into mysql-secret.yaml

```yaml
apiVersion: v1
kind: Secret
metadata:
  name: mysecret
type: Opaque
data:
  password: <passencrypted-output>
```

* Use this command to generate the secret:
``` 
kubectl apply -f mysql-secret.yaml 
```

* Create a service account with storage-admin permission and generate key (to get the JSON file). Rename the file to service-account.json and store it where your Dockerfile is going to be placed

* Create a Dockerfile with this content:
```
FROM google/cloud-sdk

COPY service-account.json service-account.json

RUN apt-get update && apt-get install -y mysql-client && rm -rf /var/lib/apt
```

* Build image:
``` 
docker build . -t gcr.io/<project_name>/<preffered-image-name>
```

* Push image:
```
docker push gcr.io/<project_name>/<preffered-image-name>
```

* Create the cronjob yaml (mysql-cronjob.yaml)
```yaml
apiVersion: batch/v1beta1
kind: CronJob
metadata:
  name: mysql-backup
spec:
  schedule: "*/10 * * * *"
  jobTemplate:
    spec:
      template:
        spec:
          restartPolicy: OnFailure
          containers:
            - name: mysql-backup
              image: gcr.io/<project_name>/<prefered-image-name>
              env:
                - name: GOOGLE_PROJECT
                  value: <google-project>
                - name: DB_HOST
                  value: wordpress-mysql
                - name: DB_USER
                  value: root
                - name: DB_NAME
                  value: mysql
                - name: DB_PASS
                  valueFrom:
                    secretKeyRef:
                      name: mysecret
                      key: password
                - name: GCS_BUCKET
                  value: <my-bucket>
                - name: GCS_SA
                  value: service-account.json
              args:
                - /bin/bash
                - -c
                - mysqldump --user="${DB_USER}" --password="${DB_PASS}" --host="${DB_HOST}" "$@" "${DB_NAME}" > "${DB_NAME}-$(date '+%d|%m|%Y-%H:%M:%S')".sql; gcloud config set project ${GOOGLE_PROJECT}; gcloud auth activate-service-account --key-file "${GCS_SA}"; gsutil cp *.sql gs://"${GCS_BUCKET}"
``` 

NOTE: This cronjob is activated every 10 mins. Check out the templates in [jobs folder](jobs)


# Clean up

Type `exit` on your *Cloud Shell* session.

Close your incognito browser window.
