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
ip="http://xxx:xx"
ns="xxx"
deploy="xxx"
floor=xxx
upper=xxx
increment=xxx
cy=xxx


logfile="ms_data.txt"
query=10000

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
         command="hey -q $query -z 20s ${ip}"
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

# 处理数据
dealed_file="dealed_log.txt"
echo "`cat $logfile | grep -e cpu_rescource: -e Requests | sed 's/Requests\/sec:/''/g'`"  > $dealed_file
echo "`sed 's/cpu_rescource:/''/g' $dealed_file`" > $dealed_file
echo "`sed 's/[ \t]+/''/g' $dealed_file`" > $dealed_file


