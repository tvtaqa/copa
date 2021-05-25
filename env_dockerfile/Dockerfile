# 基础镜像,包含COPA的运行环境以及压测环境:python3,hey等 
FROM python:3.7
RUN	apt-get update \
	&& apt-get -y install golang vim fish\
	&& go get github.com/rakyll/hey  \
	&& cp $(go env GOPATH)/bin/hey /usr/local/bin/ \
	&& pip install --upgrade pip \
	&& pip3 install kubernetes sympy pyyaml \
	&& apt-get clean