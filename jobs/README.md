#Steps to create CronJob in Kubernetes

* Connect to the cluster

* Encrypt the user, for example: echo -n 'root' | base64

* Copy output from the command above and save it into mysql-secret.yaml

* Use this command to generate the secret:
``` 
kubectl apply -f mysql-secret.yaml 
```

* Create a service account with storage-admin permission and generate key (to get JSON file). Rename file to service-account.json

* Build image:
``` 
docker build . -t gcr.io/<project_name>/<preffered-image-name>
```

* Push image:
```
docker push gcr.io/<project_name>/<preffered-image-name>
```

* Create cronjob in K8s
```
kubectl apply -f mysql-cronjob.yaml
```

NOTE: This cronjob is activated every 10 mins

### References:

https://medium.com/searce/cronjob-to-backup-mysql-on-gke-23bb706d9bbf
https://www.serverlab.ca/tutorials/containers/kubernetes/using-kubernetes-cronjob-to-backup-mysql-on-gke/
