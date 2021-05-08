#!/bin/bash
ip="http://10.101.196.176:8080"

logfile="$1.txt"
rise_query=( 500  700   1000  800   1200  1500  1800  1600  
      1900  2200  2500  2700  2400  2900  3200  3900  
      2700  2000  2100  3600  4000  4200  4900  4500  
      4800  5100  6300  5600  6100  6300  6200  7100  
      6900  7300  7800  8000  8400  8000  7700  8500  
      9100  9600  10300 8900  8700  8600  8800  9000)

burst_query=( 2000  1900  1700  1500  1800  2100  2300  3000  
        3200  3100  3500  4400  5800  6100  6300  10100 
        12700 10500 5300  6300  6100  5900  6200  4500  
        4700  6300  4600  4300  6300  6300  5900  6200  
        5500  6300  5800  6000  6300  4000  3800  3000  
        2700  2900  3000  3200  2700  2100  2500  2400)

decline_query=( 12700 12300 11000 10000 10400 12100 9700  9400  
        9000  9100  8800  8600  8000  7700  7500  7000  
        7300  7600  6900  6500  6000  5500  6200  5900  
        6300  4200  3900  3700  2900  3100  4000  4500  
        3200  3000  2800  2600  2100  1600  1900  1700  
        1400  1000  1300  1500  1100  1400  1100  1200)

gentle_query=(  5800  6300  6100  6300  7800  7100  6100  7000  
        7300  7400  7400  7600  7300  6900  7000  6800  
        7400  7300  7200  7100  7000  7000  7100  6900  
        7300  7500  8000  7700  7400  7300  7400  7600  
        7000  7100  6300  7000  7300  7400  7800  5900  
        6100  6500  7000  7300  7400  8300  6900  7100)

count=0

while [ $count -lt 48 ]
do
      if [[ "$1" = "rise" ]];then
        command="hey -q ${rise_query[$count]} -c 1 -z 60s -D ../request_body/timeservice.txt -m POST ${ip}/execute"
      elif [[ "$1" = "burst" ]]; then
        command="hey -q ${burst_query[$count]} -c 1 -z 60s -D ../request_body/timeservice.txt -m POST ${ip}/execute"
      elif [[ "$1" = "decline" ]]; then
        command="hey -q ${decline_query[$count]} -c 1 -z 60s -D ../request_body/timeservice.txt -m POST ${ip}/execute"
      else
        command="hey -q ${gentle_query[$count]} -c 1 -z 60s -D ../request_body/timeservice.txt -m POST ${ip}/execute"
      fi
      echo "$command" >> $logfile
      echo $(date +"%Y-%m-%d %H:%M:%S") >> $logfile
      echo "`$command`" >> $logfile
      echo "-------------------------------------------------------------" >> $logfile
      let count=count+1
done

