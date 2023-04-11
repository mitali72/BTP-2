from pssh.clients import ParallelSSHClient
from pssh.config import HostConfig
import os
import csv

workload_coloc_factor={
                        # "ctr_dnn_torch": [1,2,4,8,12,15],
                    #    "particle_filter": [1,2,4,8,16,32],
                    # "particle_filter": [40],
                    #    "resnet50_pytorch":[1,2,4,6,8],
                    #    "resnet50_tf":[1,2,4,8],
                    #    "vec_add": [1,2,4,8,16,24,32,40],
                    #  "vec_add": [32,40],
                    #    "vgg16_pytorch" : [1,2,3,4]
                    "video_recog_tf" : [1,2,3,4],
                    "text_classification_tf": [1,2,3,4],
                    "text_classification_pytorch": [1,2,3,4]
                       }

if __name__=="__main__":
        
    hosts = ['10.129.28.214', '10.129.28.242', '10.129.28.72', '10.129.26.80']
    # hosts = ['10.129.28.214']
    host_config = [
    HostConfig(user='vgpu-1',
            password='1234'),
    HostConfig(user='vgpu-2',
            password='1234'),
    HostConfig(user='vgpu-3',
            password='1234'),
    HostConfig(user='vgpu-4',
            password='1234'),
]
    client = ParallelSSHClient(hosts, host_config=host_config)

    output = client.run_command('source ~/mitali/scripts/start_mps.sh')
    client.join()

    for key in workload_coloc_factor:

        home = os.environ.get('HOME')
        directory = f"mitali/profiling/coloc_homo/latency/{key}/"
        directory = os.path.join(home,directory)

        if not os.path.exists(directory):
            os.makedirs(directory)
        with open(os.path.join(directory,"mps_4vgpu.csv"),"w") as fthr:
            dictwriter_object = csv.DictWriter(fthr, fieldnames=["NumOfProcesses","Throughput", "Latency"])
            dictwriter_object.writeheader()

        coloc_factor = workload_coloc_factor[key]

        for num_proc in coloc_factor:
            print(key, num_proc)
            time_taken = -1e9
            if num_proc<=4:
                
                client.hosts = hosts[:num_proc]
                # shells = client.open_shell()
                # client.run_shell_commands(shells, ['. ~/.bashrc', f'bash ~/mitali/workload_executables/{key} 100 1'])
                # client.join_shells(shells)
                output = client.run_command(f'~/mitali/workload_executables/{key} 100 1')
                client.join()
                
                    
            else:
                rem = num_proc%4
                n = num_proc//len(hosts)
                n_vm = []
                for i in range(4):
                    if rem!=0:
                        n_vm.append(str(n+1))
                        rem -= 1
                    else:
                        n_vm.append(str(n))

                client.hosts = hosts
                print(n_vm)
                output = client.run_command('~/mitali/workload_executables/%s 100 %s',host_args = ((key,n_vm[0]),(key,n_vm[1]), (key,n_vm[2]), (key,n_vm[3]), ))
                client.join()

            for host_output in output:
                # print(host_output)
                for line in host_output.stdout:
                    print(line)
                    time_taken = max(time_taken, float(line))
                    # print(time_taken)
                for line in host_output.stderr:
                    print("error: ",line)

            with open(os.path.join(directory,"mps_4vgpu.csv"),"a") as fthr:
                dictwriter_object = csv.DictWriter(fthr, fieldnames=["NumOfProcesses","Throughput", "Latency"])
                row = {"NumOfProcesses":num_proc, "Throughput": round(num_proc/time_taken,3), "Latency": time_taken}
                dictwriter_object.writerow(row)

# time_taken = max(time_taken, float(stdout.read().decode("utf-8").splitlines()[0]))
    # output = client.run_command('whoami')
    # client.join()

    # for host_output in output:
    #     hostname = host_output.host
    #     stdout = list(host_output.stdout)
    #     print("Host %s: exit code %s, output %s" % (
    #         hostname, host_output.exit_code, stdout))


    # for shell in shells:
    #     # for line in shell.stdout:
    #     #     print(line)
    #     for line in shell.stderr:
    #         print(line)