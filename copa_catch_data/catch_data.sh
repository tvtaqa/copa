#!/bin/bash

# 脚本的功能：
# 通过垂直伸缩，改变微服务实例的资源量
# 在不同的资源量下，做压测，得到TPS值(每秒能处理多少请求)
# 最终得到的数据是以key-value的形式，如：
# <res_1,tps_1>
# <res_2,tps_2>
# ...
# 一种资源量对应一个TPS值


# to be written
ip="http://10.101.196.176:8080"
ns="service-scalling"
deploy="tableservice"
floor=500
upper=3000
increment=100
cy=3


# this is an example
# ip="http://10.107.142.125:80"
# ns="hy"
# deploy="php-apache-hy"
# floor=100
# upper=250
# increment=50
# cy=2


#  一个较大的值，用于压测，目的在于体现出在某种资源量下的TPS
query=1000000

logfile="catch_log.txt"
dealed_file="dealed_log.txt"

while [[ $floor -le $upper ]]
do 
      #  通过调用vpa.py改变资源量 资源量通过外部传参
      python3 vpa.py ${floor}
      sleep 60
      cycle=0
      while [[ $cycle -lt $cy ]]
      do
         command="hey -q $query -z 20s -D ../request_body/tableservice.txt -m POST ${ip}/execute"
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
echo "catch data end... next deal the data" >> ${logfile}


# 原始数据的形式
# 第一行：cpu_rescource: 1000m
# 第二行开始：hey的日志...
# 有效的信息只有<res,tps>
# 下面的代码，对数据进行抽取
echo "`cat $logfile | grep -e cpu_rescource: -e Requests | sed 's/Requests\/sec:/''/g'`"  > $dealed_file
echo "`sed 's/cpu_rescource:/''/g' $dealed_file`" > $dealed_file
echo "`sed 's/[ \t]+/''/g' $dealed_file`" > $dealed_file


# 抽取后的数据形式如下：
# <res_1,tps_1_1>
# <res_1,tps_1_2>
# <res_1,tps_1_3>
# ...
# 需要对上述的数据求平均值
echo "Now getting the average data" >> ${logfile}
python3 deal.py


