#!/bin/bash
ori_file="log.txt"
dealed_file="dealed_log.txt"
echo "`cat $ori_file | grep -e cpu_rescource: -e Requests | sed 's/Requests\/sec:/''/g'`"  > $dealed_file
echo "`sed 's/cpu_rescource:/''/g' $dealed_file`" > $dealed_file
echo "`sed 's/[ \t]+/''/g' $dealed_file`" > $dealed_file