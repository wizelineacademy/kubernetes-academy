#!/bin/bash

for ((i=1;i<=200;i++));
do
    kubectl create namespace namespace-${i}
    kubectl -n namespace-${i} create deployment nginx --image=nginx:latest
    kubectl -n namespace-${i} scale deployment nginx --replicas=3
    kubectl -n namespace-${i} expose deployment nginx --port=8${i} --target-port=80 --type=LoadBalancer
    sleep 1
done