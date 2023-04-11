set term postscript eps background rgb 'white' color 'Verdana,30'
# set output '/home/ub-11/mitali/plots/resent50_pytorch/ubench_resnet50_pytorch.eps'
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
set ylabel "SM Active (%)"
set xlabel "Time (s)"
set yrange [0:115]
# high
set xrange [5:20]
# bursty
# set xrange [20:40]
# set xtics 0,2,32
# Actually do the plot; use cols 2-4 from the file; linecolor gives the color, 
# linewidth 0 removes the outline of the column
# set datafile separator ","
# plot "bursty_avg2.csv" using ($1/1000000000):($2) with lines title "ResNet50"
# plot "high_avg2.csv" using ($1/1000000000):($2) with lines title "Particle Filter", \
#     "high_avg2.csv" using ($1/1000000000):($3) with lines title "Transmitted"
# plot for [i=5:5:1] '/home/ub-11/mitali/profiling/ubench_resnet50_pytorch_'.(2**i).'.csv' using ($1/1000000000):($2) with lines title 'batch size '.(2**i)
# FILES = system("ls profiling/*.csv | sed -e 's/\.csv$//")
# plot for [file in system("ls profiling/*.csv | sed -e 's/\.csv$//")] set output '/home/ub-11/mitali/plots/resent50_pytorch/'.file.".eps",\
# for [file in system("ls profiling/*.csv | sed -e 's/\.csv$//")] '/home/ub-11/mitali/profiling/'.file.".csv" using ($1/1000000000):($2) with lines,\
# for [file in system("ls profiling/*.csv | sed -e 's/\.csv$//")]
# replot

do for [file in system("ls ../profiling/*.csv | sed -e 's/\.csv$//' | xargs -n 1 basename")]{
    set output '/home/ub-11/mitali/plots/resent50_pytorch/'.file.".eps"
    plot '/home/ub-11/mitali/profiling/'.file.".csv" using ($1/1000000000):($2) with lines
    # replot
}