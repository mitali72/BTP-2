#!/bin/bash
# Colocated functions n
# run in profiling directory
TIMEFORMAT=%R
# n=$1
# mem=$((16384/4))
# cores=$((100/4))
eval "$(conda shell.bash hook)"
conda activate my_tf

python3 /home/ub-11/mitali/workloads/resnet50_tf.py --batch-size 256