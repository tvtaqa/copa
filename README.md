## 安装

1.	git clone https://github.com/tvtaqa/copa.git

2.	首先注册对应的集群角色，并与默认的serviceaccount进行绑定
```
kubectl create -f RBAC.yaml
```

3.	部署相应的微服务，需要使用的关键信息：
* namespace
* deployment
* cluster-ip

例如，如下部署了一组php实现的md5加密服务
```
 kubectl create -f example-deployment/php_deploy_svc.yaml
```

4.	进入copa-v1，首先通过垂直伸缩的方式，采集不同资源量下，单个微服务实例的TPS
```
kubectl run -i --tty copa-v1 --image=registry.cn-shanghai.aliyuncs.com/tvtaqa/copa:v1.0 /bin/sh
```
注：如果镜像pull得较快，会直接进入pod；如果未能进入pod，通过exec命令进入。
```
kubectl exec -it copa-v1 /bin/bash
```

### 采集单个微服务的性能数据
进入pod后，所处的路径为/copa

```
cd catch_data
```

在运行之前，catch_data.sh脚本需要填写的信息如下：
```
ip="http://xxx:xx" # cluster-ip
ns="xxx"	#namespace
deploy="xxx"    #deployment
floor=xxx	#压测时，cpu资源量的下限
upper=xxx	#压测时，cpu资源量的上限
increment=xxx   #资源量，每一次的增量
cy=xxx   #一种资源量下，重复cy次压测
```

arg.yaml文件需要填写的信息如下:
```
'namespace': 'XXX'
'deployment': 'XXX'
```


执行sh脚本
```
chmod +x catch_data.sh && ./catch_data.sh
```

### 组合式伸缩与压测

XXX


## To do
* 目前版本的微服务数据采集都是硬编码的方式，如果是自定义的微服务，需要做修改
* 同时运行压测模块 以及 弹性伸缩模块
* 上述的负载需要统一 gentle，burst，decline等
* 对比伸缩方案（K8s HPA）











