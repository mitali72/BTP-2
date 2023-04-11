#!/bin/bash
# PNAME="$1"
LOG_FILE=$HOME/mitali/profiling/ubench/cpu_util/cpuLog_vec_add
# PID=$(pidof ${PNAME})

cmd="/home/ub-11/mitali/workload_executables/vec_add"
eval $cmd & my_pid=$!
echo $my_pid
wait
# top -b -d 2 -p $my_pid
# | awk -v cpuLog="$LOG_FILE" ' ^top -/{time = $3} $1+0>0 {printf "%s %s :: CPU Usage: %d%%\n", strftime("%Y-%m-%d"), $9 > cpuLog fflush(cpuLog)}'