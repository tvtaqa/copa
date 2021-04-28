FROM registry.cn-shanghai.aliyuncs.com/tvtaqa/copa_env:v1
COPY . /copa
WORKDIR /copa
RUN chmod +x run.sh
CMD ["/bin/bash","-c"]
