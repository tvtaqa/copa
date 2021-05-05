## Introduction
COPA是一个面向k8s的组合式伸缩器，借助于python的第三方库，实现的一个简单的prototype。该伸缩器根据实时的请求量、期望的响应时间、以及正在使用的实例配置方案，借助于排队论模型，定期地确定最优的伸缩方案。

## installation and how to use
1. git clone 该项目
2. 在K8s集群中，部署待伸缩的微服务，并修改以下两个文件
   * hey_load.sh:
  
        line 2中的ip对应微服务的clusterip
   * 同理，arg.yaml中的两个参数: 

        'namespace': 'xx'

        'deployment': 'xx'
3. 修改load.txt以及hey_load.sh里面的负载数据
4. docker build -t tvtaqa/copa:v1 .
5. kubectl run -i --tty copa-pod --image=tvtaqa/copa:v1  /bin/sh
6. 在pod中，执行脚本，即可同时进行压测并执行伸缩


or

如果不修改负载数据，则可直接运行
```
kubectl run -i --tty copa-pod-beta --image=registry.cn-shanghai.aliyuncs.com/tvtaqa/copa:v2  /bin/sh
```








