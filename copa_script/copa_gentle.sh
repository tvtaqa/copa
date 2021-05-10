#!/bin/bash
# gentle
cd ..
cd copa_autoscaling
nohup python3 hybrid.py gentle &
cd ..

cd copa_load_simulate
chmod +x hey_load.sh
nohup ./hey_load.sh gentle > hey_log.txt 2>&1 &!
