set term postscript eps background rgb 'white' color 'Verdana,30'
# set output '/home/ub-11/mitali/plots/resent50_pytorch/ubench_resnet50_pytorch_pcie.eps'
set datafile separator ","
set key autotitle columnhead
unset key
# set style data histogram
# set style histogram cluster gap 1
# res = "#99ffff"; unres = "#4671d5"
# set boxwidth 0.9
# No xtics, but we do want labels, and do not mirror tics (ie show at top)
# set xtics format "" nomirror
# y tic marks plus grid lines
# set grid ytics
# Control the look of the error bars
# set style histogram errorbars linewidth 2
# set errorbars linecolor black
# set bars front
# Define some custom colours using RGB; can also use standard names ("blue")
# red = "#FF0000"; green = "#00FF00"; blue = "#0000FF"; skyblue = "#87CEEB";
set key top
set ylabel "PCIe Throughput (%)"
set xlabel "Time (s)"
# set yrange [0:10]
set yrange [0:30]
# high
set xrange [5:20]
# plot for [i=5:5:1] '/home/ub-11/mitali/profiling/ubench_resnet50_pytorch_'.(2**i).'.csv' using ($1/1000000000):($3) with lines title 'Transmitted' ,\
#     for [i=5:5:1] \
#     '/home/ub-11/mitali/profiling/ubench_resnet50_pytorch_'.(2**i).'.csv' using ($1/1000000000):($4) with lines title 'Received'
# replot

do for [file in system("ls ../profiling/*.csv | sed -e 's/\.csv$//' | xargs -n 1 basename")]{
    set output '/home/ub-11/mitali/plots/resent50_pytorch/'.file."_pcie.eps"
    plot '/home/ub-11/mitali/profiling/'.file.".csv" using ($1/1000000000):($3) with lines title 'Transmitted' ,\
        '/home/ub-11/mitali/profiling/'.file.".csv" using ($1/1000000000):($4) with lines title 'Received'
    # replot
}