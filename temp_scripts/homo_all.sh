#!/bin/bash
# Colocated functions n
# n=$1
mem=$((16384/8))
cores=$((100/8))

source ~/pramod/set_gpu_limits.sh "0=${mem}MB" $cores%
for((iter=5;iter<=8;iter++))
do  
    echo "evaluating for n = ${iter}">>log_high
    cmd='/home/ub-11/mitali/rodinia_3.1/cuda/particlefilter/particlefilter_float -x 128 -y 128 -z 10 -np 1000000 &>> log_high &'
    final_cmd=''
    for((c=1;c<=$iter;c++))
    do
        final_cmd="$final_cmd $cmd"
    done
    eval $final_cmd
    wait
done

for((iter=1;iter<=8;iter++))
do  
    echo "evaluating for n = ${iter}">>log_moderate
    cmd='/home/ub-11/mitali/rodinia_3.1/cuda/srad/srad_v1/srad 1000000 0.5 128 128 &>> log_moderate &'
    final_cmd=''
    for((c=1;c<=$iter;c++))
    do
        final_cmd="$final_cmd $cmd"
    done
    eval $final_cmd
    wait
done
# eval $final_cmd
wait