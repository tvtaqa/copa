#!/bin/bash

read -t 60 -p "Enter the ip:port of the service > " ip
echo "service_ip: $ip"
echo -e "\n"

read -t 60 -p "Enter the namespace and deployment > " ns deploy
echo "namespace: $ns"
echo "deployment: $deploy"
echo -e "\n"

read -t 60 -p "Enter the floor, upper, increment cpu > " floor upper increment
echo "floor: $floor "
echo "upper: $upper "
echo "increment: $increment"
echo -e "\n"

read -t 60 -p "Enter the cycle > " cy
echo "cycle: $cy"
echo -e "\n"