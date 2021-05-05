#!/bin/bash
APISERVER=$(kubectl config view | grep server | cut -f 2- -d ":" | tr -d " ")
TOKEN=$(kubectl describe secret $(kubectl get secrets | grep default | cut -f1 -d ' ') | grep -E '^token' | cut -f2 -d':' | tr -d ' ')


echo $TOKEN
echo -e "\n"
curl $APISERVER/api --header "Authorization: Bearer $TOKEN" --insecure