# 伸缩测试
## COPA伸缩
测试使用的微服务为tableservice，且已完成服务的部署和数据采集部分，可直接进入copa的pod进行伸缩测试(步骤1、2、3可以跳过)。
### COPA测试流程
1. 部署相应的服务，此为tableservice
```
cd deploy_file/
kubectl create -f tableservice.yaml
```
2. 部署copa的pod
```
kubectl run -i --tty copa --image=registry.cn-shanghai.aliyuncs.com/tvtaqa/copa:v1.6 --namespace=service-scalling  /bin/sh
```
3. 采集tableservice的相关数据
```
cd copa_catch_data/
kubectl exec -it copa-v1-5 -n  service-scalling  /bin/bash
cd catch_data

#   在运行之前，两个文件需要填写参数。
#   catch_data.sh脚本需要填写的信息如下：
ip="http://xxx:xx" # cluster-ip
ns="xxx"	#namespace
deploy="xxx"    #deployment
floor=xxx	#压测时，cpu资源量的下限
upper=xxx	#压测时，cpu资源量的上限
increment=xxx   #资源量，每一次的增量
cy=xxx   #一种资源量下，重复cy次压测


#   arg.yaml文件需要填写的信息如下,python文件使用的参数:
'namespace': 'XXX'
'deployment': 'XXX'


chmod +x catch_data.sh
nohup ./catch_data.sh & 
```
脚本运行完成后，会生成ms_data.txt文件；该文件已经对数据做完处理，能直接使用

4. 运行COPA伸缩器及压测

测试的pod中预设了4种负载类型，分别为burst、gentle、rise、decline类型。每一种负载下，压测和copa都会运行48分钟。
```
cd copa_script/
chmod +x copa_*.sh
# 根据burst类型进行负载模拟(压测)，同时启动copa进
./copa_burst.sh 

./copa_gentle.sh 
   
./copa_decline.sh 

./copa_rise.sh 
```

**注：在执行完shell脚本后，使用 ps -ef查看一下运行的进程,确认一下是否有python3 hybrid进程。有时候会出现：执行完shell脚本，但是py文件不执行的情况。如果发生这种情况，kill掉shell脚本，重新执行一遍即可**


### COPA日志说明
由copa输出的日志文件有两个txt文本。
* /copa/copa_autoscaling/hybrid_result.txt，示例如下：
```
2021-05-09 05:42:13     #   日志时间
current index: 15       #   每分钟更换负载量，代表15分钟
load: 7070              #   负载量
pod_num: 3              #   此时的pod个数
pod_res: 1000           #   单个pod的cpu资源量
pod_total_res: 3000     #   该微服务的总资源量
pod_rps: 2572.903933    #   单个pod的理论tps
pod_total_rps: 7718     #   微服务的理论tps
svc_ws: 0.003534        #   理论的请求响应时间
svc_pro: 100.000000     #   服务可用性，100%即不违约
res_cost: 0.005835      #   资源成本
sla_cost: 0.000000      #   违约成本
```

* /copa/copa_autoscaling/hybrid_log.txt，该文件是具体的日志，包含当前微服务示例方案与推荐方案的决策，示例如下：
```
2021-05-09 03:45:12
当前索引: 0
当前的load: 350
推荐方案的得分：2.000000 vs 旧方案的得分：1.928571
推荐方案的的rps: 664.124167 vs 旧方案的rps：3982.000000
推荐方案的的num: 3 vs 旧方案的num：1
推荐方案的CPU资源量: 900 vs 旧方案的CPU资源量：1500
推荐方案的的res: 300 vs 旧方案的res: 1500
推荐方案的的ws: 0.001518 vs 旧方案的ws：0.000275
推荐方案的的概率: 100.000000 vs 旧方案的的概率: 100.000000
```

实际微服务的请求响应时延，由压测工具提供，如果测试的是burst类型的负载，则在loadtest文件下，有一个burst文件，其中记录具体各个时刻的时延信息。
* /copa/copa_load_simulate/burst.txt: 第一行为hey命令，第二行为时间，第三行开始是hey工具的日志
```
hey -q 1680 -c 1 -z 60s -D ../request_body/tableservice.txt -m POST http://10.101.196.176:8080/execute
2021-05-09 06:14:16

Summary:
  Total:        60.0004 secs
  Slowest:      0.0397 secs
  Fastest:      0.0003 secs
  Average:      0.0005 secs
  Requests/sec: 1316.7075
  
  Total data:   11130793 bytes
  Size/request: 140 bytes

Response time histogram:
  0.000 [1]     |
  0.004 [78382] |■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
  0.008 [11]    |
  0.012 [9]     |
  0.016 [53]    |
  0.020 [137]   |

Latency distribution:
  10% in 0.0003 secs
  25% in 0.0004 secs
  50% in 0.0004 secs
  75% in 0.0004 secs
  90% in 0.0004 secs
  95% in 0.0005 secs
  99% in 0.0010 secs

Details (average, fastest, slowest):
  DNS+dialup:   0.0000 secs, 0.0000 secs, 0.0006 secs
  DNS-lookup:   0.0000 secs, 0.0000 secs, 0.0000 secs
  req write:    0.0000 secs, 0.0000 secs, 0.0007 secs
  resp wait:    0.0005 secs, 0.0002 secs, 0.0396 secs
  resp read:    0.0000 secs, 0.0000 secs, 0.0010 secs

Status code distribution:
  [200] 79003 responses
```

***

## HPA伸缩
HPA的测试比较简单，只需要给tableservice注册一个HPA，设定好基础的参数，如初始的资源量，触发伸缩的条件。接着使用写好的脚本，脚本中调用hey进行压测。因此HPA的测试可以分为初始化以及压测两部分。
### HPA测试流程


1. HPA初始化
  
初始化脚本hpa.sh在master节点上，直接执行即可
。
```
cd /root/hqc
chmod +x hpa.sh && ./hpa.sh
```

2. HPA压测
   
压测的脚本是在pod中的hpa_script目录下，里面有一个shell脚本，在执行shell脚本的时候，在后面跟上负载类型即可（预设的负载类型有 burst,rise,gentle,decline）

```
cd hpa_script/
chmod +x hpa_load.sh
nohup ./hpa_load.sh burst &
```

### HPA日志说明
hey的日志在hpa_script目录下，日志的形式与COPA一样，如上。