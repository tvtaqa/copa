#!/bin/bash
# decline
cd ..
cd copa_autoscaling
nohup python3 hybrid.py decline &
cd ..

cd copa_load_simulate
chmod +x hey_load.sh
nohup ./hey_load.sh decline > hey_log.txt 2>&1 &!
