#!/bin/bash

# read -t 60 -p "Enter the interval > " interval
# echo "interval: $interval"
# echo -e "\n"

# read -t 60 -p "Enter the type of workload > " workload
# echo "workload: $workload"
# echo -e "\n"

ip="http://10.101.196.176:8080"


logfile="$1.txt"
rise_query=( 1000  1400  2000  1600  2400  3000
        3600  3200  3800  4400  5000  5400  
        4800  5800  6400  7800  5400  4000  
        4200  7200  8000  8400  9800  9000  
        9600  10200 12600 11200 12200 12600 
        12400 14200 13800 14600 15600 16000 
        16800 16000 15400 17000 18200 19200 
        20600 17800 17400 17200 17600 18000)

count=0
#kubectl delete hpa php-apache -n test
#kubectl autoscale deployment php-apache -n test --cpu-percent=80 --min=1 --max=10
#kubectl scale --replicas=1 deploy/php-apache -n test
#kubectl set resources deployment php-apache -n test  --limits=cpu=675m --requests=cpu=675m
while [ $count -lt 48 ]
do
      if [[ "$1" = "rise" ]];then
        command="hey -q ${rise_query[$count]} -c 1 -z 60s -D ../request_body/timeservice.txt -m POST ${ip}/execute"
      elif [[ "$1" = "gentle" ]]; then
        command="hey -q ${rise_query[$count]} -c 1 -z 60s -D ../request_body/timeservice.txt -m POST ${ip}/execute"
      else
        command="hey -q ${rise_query[$count]} -c 1 -z 60s -D ../request_body/timeservice.txt -m POST ${ip}/execute"
      echo "$command" >> $logfile
      echo $(date +"%Y-%m-%d %H:%M:%S") >> $logfile
      echo "`$command`" >> $logfile
      echo "-------------------------------------------------------------" >> $logfile
      let count=count+1
done