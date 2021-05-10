#!/bin/bash
ip="http://10.101.196.176:8080"




logfile="$1.txt"
rise_query=( 	350	490	700	560	840	1050	1260	1120	
	1330	1540	1750	1890	1680	2030	2240	
	2730	1890	1400	1470	2520	2800	2940	
	3430	3150	3360	3570	4410	3920	4270	
	4410	4340	4970	4830	5110	5460	5600	
	5880	5600	5390	5950	6370	6720	7210	
	6230	6090	6020	6160	6300
)

burst_query=(	1400	1330	1190	1050	1260	1470	1610	2100	
				2240	2170	2450	3080	4060	4270	4410	7070	
				8890	7350	3710	4410	4270	4130	4340	3150	
				3290	4410	3220	3010	4410	4410	4130	4340	
				3850	4410	4060	4200	4410	2800	2660	2100	
				1890	2030	2100	2240	1890	1470	1750	1680)

decline_query=(		8890	8610	7700	7000	7280	8470	6790	6580	
					6300	6370	6160	6020	5600	5390	5250	4900	
					5110	5320	4830	4550	4200	3850	4340	4130	
					4410	2940	2730	2590	2030	2170	2800	3150	
					2240	2100	1960	1820	1470	1120	1330	1190	
					980		700		910		1050	770		980		770		840
	)

gentle_query=(	4060	4410	4270	4410	5460	4970	4270	4900	
				5110	5180	5180	5320	5110	4830	4900	4760	
				5180	5110	5040	4970	4900	4900	4970	4830	
				5110	5250	5600	5390	5180	5110	5180	5320	
				4900	4970	4410	4900	5110	5180	5460	4130	
				4270	4550	4900	5110	5180	5810	4830	4970)

count=0
# kubectl delete hpa tableservice -n service-scalling
# kubectl autoscale deployment tableservice -n service-scalling --cpu-percent=80 --min=1 --max=10
# kubectl scale --replicas=1 deploy/tableservice -n service-scalling
# kubectl set resources deployment tableservice -n service-scalling  --limits=cpu=1500m --requests=cpu=1500m
while [ $count -lt 48 ]
do
      if [[ "$1" = "rise" ]];then
        command="hey -q ${rise_query[$count]} -c 1 -z 60s -D ../request_body/tableservice.txt -m POST ${ip}/execute"
      elif [[ "$1" = "burst" ]]; then
        command="hey -q ${burst_query[$count]} -c 1 -z 60s -D ../request_body/tableservice.txt -m POST ${ip}/execute"
      elif [[ "$1" = "decline" ]]; then
        command="hey -q ${decline_query[$count]} -c 1 -z 60s -D ../request_body/tableservice.txt -m POST ${ip}/execute"
      else
        command="hey -q ${gentle_query[$count]} -c 1 -z 60s -D ../request_body/tableservice.txt -m POST ${ip}/execute"
      fi
      echo "$command" >> $logfile
      echo $(date +"%Y-%m-%d %H:%M:%S") >> $logfile
      echo "`$command`" >> $logfile
      echo "-------------------------------------------------------------" >> $logfile
      let count=count+1
done

