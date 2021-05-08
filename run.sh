#!/bin/bash
cd autoscaling
nohup python3 hybrid.py rise &
cd ..

cd loadtest
chmod +x hey_load.sh
nohup ./hey_load.sh rise > hey_log.txt 2>&1 &!