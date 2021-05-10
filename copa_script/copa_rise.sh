#!/bin/bash
# rise
cd ..
cd copa_autoscaling
nohup python3 hybrid.py rise &
cd ..

cd copa_load_simulate
chmod +x hey_load.sh
nohup ./hey_load.sh rise > hey_log.txt 2>&1 &!
