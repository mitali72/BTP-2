import pandas as pd
import os
import csv
from pathlib import Path

# use my_tf env

if __name__ == "__main__":
    step = 1000
    home = os.environ.get('HOME')
    profile_gpu_path = os.path.join(home,'mitali/profiling/solo/gpu_util')
    latency_path = os.path.join(home, "mitali/profiling/solo/latency")
    for f in os.listdir(profile_gpu_path):
        if f.endswith(".csv"):
            m_df = pd.read_csv(os.path.join(profile_gpu_path, f))
            latency = float(m_df['rawTimestamp'].iloc[-1])/1e9
            with open(os.path.join(latency_path,"_".join(Path(f).stem.split("_")[:-1])+".csv"),"a") as flat:
                writer = csv.writer(flat)
                writer.writerow([int(Path(f).stem.split("_")[-1]),round(latency,3)])

            df = m_df.groupby(m_df.index // step).mean()
            df.to_csv(os.path.join(profile_gpu_path, f), sep=',', index = False)