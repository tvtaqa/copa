import math
import random
import time
from kubernetes import client, config
from sympy import *
import yaml



deployment, namespace = 'php-apache-hy', 'hy'


def decide():
    execute(1, 1950)


def execute(num_pod, limit_pod):
    config.load_kube_config()
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



def main():
    decide()



if __name__ == '__main__':
    main()
