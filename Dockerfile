FROM registry.cn-shanghai.aliyuncs.com/tvtaqa/copa_env:v1
COPY . /copa
WORKDIR /copa
CMD ["/bin/bash","-c"]
