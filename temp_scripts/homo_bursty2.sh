#!/bin/bash
eval "$(conda shell.bash hook)"
# Colocated functions n

TIMEFORMAT=%R
n=$1
mem=4096
cores=25%
conda activate tf
source ~/pramod/set_gpu_limits.sh "0=${mem}MB" $cores%
cmd="time python3 /home/ub-11/pramod/image_recognition/resnet_bursty.py --batch-size 150 &"
# final_cmd=""
for((c=1;c<=$n-1;c++))
do
    final_cmd+="$cmd"$'\n'
done
final_cmd+="$cmd"
# echo "$final_cmd"
eval $final_cmd
# time (python3 /home/ub-11/mitali/image_recognition/resnet50_pytorch.py --batch-size 1 --total-images 2500) &>> record1 &
# time (python3 /home/ub-11/mitali/image_recognition/resnet50_pytorch.py --batch-size 1 --total-images 2500) &>> record1 &
wait