# 功能概述：
# 调用python的kubernetes client库，实现简单的垂直伸缩
# 在pod内部和api-server交互，修改目标deployment的资源量 


# Input:
# arg.yaml,外部传入的<期望的资源量>

# Output:
# 无

import sys
from kubernetes import client, config
import yaml

_YAML_FILE_NAME='arg.yaml'

deployment, namespace = '', ''


def execute(num_pod, limit_pod):
    config.load_incluster_config()
    api_instance = client.AppsV1Api()
    deployobj = api_instance.read_namespaced_deployment(deployment, namespace)

    recommend_cpu_requests = int(limit_pod)

    recommend_cpu_limits = int(limit_pod)

    recommend_requests = {
        'cpu': str(recommend_cpu_requests) + 'm',

    }
    recommend_limits = {
        'cpu': str(recommend_cpu_limits) + 'm',

    }
    deployobj.spec.template.spec.containers[0].resources.limits.update(recommend_limits)
    deployobj.spec.template.spec.containers[0].resources.requests.update(recommend_requests)
    deployobj.spec.replicas = num_pod
    api_instance.replace_namespaced_deployment(deployment, namespace, deployobj)



def set_arg(arg):
    global deployment, namespace
    deployment = arg['deployment']
    namespace = arg['namespace']

def main():
    with open(_YAML_FILE_NAME) as f:
        arg = yaml.load(f, Loader=yaml.FullLoader)

    set_arg(arg)

    res = sys.argv[1]

    execute(1,res)



if __name__ == '__main__':
    main()
