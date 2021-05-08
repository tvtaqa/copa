#!/bin/bash

# example
# ip="http://10.107.142.125:80"
# ns="hy"
# deploy="php-apache-hy"
# floor=100
# upper=250
# increment=50
# cy=2


# to be written
ip="http://10.101.196.176:8080"
ns="service-scalling"
deploy="tableservice"
floor=500
upper=4000
increment=100
cy=3


logfile="catch_log.txt"
query=1000000

# read -t 60 -p "Enter the ip:port of the service > " ip
# echo "service_ip: $ip"
# echo -e "\n"

# read -t 60 -p "Enter the namespace and deployment > " ns deploy
# echo "namespace: $ns"
# echo "deployment: $deploy"
# echo -e "\n"

# read -t 60 -p "Enter the floor, upper, increment of the CPU > " floor upper increment
# echo "floor: $floor "
# echo "upper: $upper "
# echo "increment: $increment"
# echo -e "\n"

# read -t 60 -p "Enter the cycle > " cy
# echo "cycle: $cy"
# echo -e "\n"


while [[ $floor -le $upper ]]
do 
      python3 vpa.py ${floor}
      sleep 60
      cycle=0
      while [[ $cycle -lt $cy ]]
      do
         #hey -c 500  -z 2s -D timeservice.txt -m POST http://127.0.0.1:8080/execute
         #command="hey -q $query -z 20s ${ip}"
         
         command="hey -q $query -z 20s -D ../request_body/timeservice.txt -m POST ${ip}/execute"
         echo "$command" >> ${logfile}
         echo "cpu_rescource: ${floor}" >> ${logfile}
         echo $(date +"%Y-%m-%d %H:%M:%S") >> ${logfile}
         echo "`$command`" >> ${logfile}
         echo "-------------------------------------------------------------" >> ${logfile}
         let cycle=cycle+1
         sleep 3
      done
      let floor=floor+increment
done

echo "catch data end... now dealing the data" >> ${logfile}
# 处理数据
dealed_file="dealed_log.txt"
echo "`cat $logfile | grep -e cpu_rescource: -e Requests | sed 's/Requests\/sec:/''/g'`"  > $dealed_file
echo "`sed 's/cpu_rescource:/''/g' $dealed_file`" > $dealed_file
echo "`sed 's/[ \t]+/''/g' $dealed_file`" > $dealed_file


echo "Now getting the average data" >> ${logfile}
python3 deal.py


