import pandas as pd
import argparse
import csv
import os

if __name__=="__main__":
    # parser = argparse.ArgumentParser(description='Simulation of a P2P Cryptocurrency Network')
    # parser.add_argument('--csv1', help='gpumem by size', default="temp_gpumemsizesum.csv")
    # parser.add_argument('--csv2', help='gpumem by time', default="temp_gpumemtimesum.csv")
    # args = parser.parse_args()

    # csv1 = pd.read_csv(args.csv1)
    # csv2 = pd.read_csv(args.csv2)
   
    home = os.environ.get('HOME')
    main_path = os.path.join(home,'mitali/profiling/coloc_homo/')

    for workload in os.listdir(main_path):
        gpumem_path = os.path.join(main_path, workload, "gpu_mem")

        csv1 = pd.read_csv(os.path.join(gpumem_path,"size.csv"))
        csv2 = pd.read_csv(os.path.join(gpumem_path,"time.csv"))

        merged_data = csv1.merge(csv2,on=["Operation"])
        merged_data.to_csv(os.path.join(gpumem_path,"gpumem.csv"), sep=',', index = False)

# nsys stats -r gpumemsizesum /home/ub-11/.nsightsystems/Projects/Project\ 1/Report\ 120.sqlite --force-overwrite --format csv -o ../my | cat ../my_gpumemsizesum.csv| cut -d ',' -f1,2,8 > ../my.csv

# nsys stats -r gpumemtimesum /home/ub-11/.nsightsystems/Projects/Project\ 1/Report\ 120.sqlite --force-overwrite --format csv -o ../my | cat ../my_gpumemtimesum.csv| cut -d ',' -f1,2,9 > ../my_time.csv