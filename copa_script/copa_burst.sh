#!/bin/bash
# burst
cd ..
cd copa_autoscaling
nohup python3 hybrid.py burst &
cd ..

cd copa_load_simulate
chmod +x hey_load.sh
nohup ./hey_load.sh burst > hey_log.txt 2>&1 &!