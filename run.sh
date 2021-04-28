#!/bin/bash
chmod +x hey_load.sh hybrid.py
nohup ./hey_load.sh > hey_log.txt 2>&1 &!
nohup python3 hybrid.py > py_log.txt 2>&1 &!