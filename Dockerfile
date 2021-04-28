FROM registry.cn-shanghai.aliyuncs.com/tvtaqa/copa_env:v1
COPY . /copa
WORKDIR /copa
RUN chmod +x hybrid.py
CMD ["/bin/bash","-c"]
