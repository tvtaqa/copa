#!/bin/bash
ip="http://10.101.196.176:8080"




logfile="$1.txt"

rise_query=(  140 196 280 224 336 420 504 448  
)

burst_query=( 140  290  500  550  200  133 100  200
        )

decline_query=(   789  650  666  545  501  439  149  100  
          
  )

gentle_query=(  406  441  427  441  546  497  427  490 
        )


count=0
# kubectl delete hpa tableservice -n service-scalling
# kubectl autoscale deployment tableservice -n service-scalling --cpu-percent=80 --min=1 --max=10
# kubectl scale --replicas=1 deploy/tableservice -n service-scalling
# kubectl set resources deployment tableservice -n service-scalling  --limits=cpu=1500m --requests=cpu=1500m
while [ $count -lt 8 ]
do
      if [[ "$1" = "rise" ]];then
        command="hey -q ${rise_query[$count]} -c 10 -z 60s -D ../request_body/tableservice.txt -m POST ${ip}/execute"
      elif [[ "$1" = "burst" ]]; then
        command="hey -q ${burst_query[$count]} -c 10 -z 60s -D ../request_body/tableservice.txt -m POST ${ip}/execute"
      elif [[ "$1" = "decline" ]]; then
        command="hey -q ${decline_query[$count]} -c 10 -z 60s -D ../request_body/tableservice.txt -m POST ${ip}/execute"
      else
        command="hey -q ${gentle_query[$count]} -c 10 -z 60s -D ../request_body/tableservice.txt -m POST ${ip}/execute"
      fi
      echo "$command" >> $logfile
      echo $(date +"%Y-%m-%d %H:%M:%S") >> $logfile
      echo "`$command`" >> $logfile
      echo "-------------------------------------------------------------" >> $logfile
      let count=count+1
done

