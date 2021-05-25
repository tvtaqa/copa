FROM registry.cn-shanghai.aliyuncs.com/tvtaqa/copa_env:v2
COPY . /copa
WORKDIR /copa
CMD ["/bin/bash","-c"]
