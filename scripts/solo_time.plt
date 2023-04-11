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
set ylabel "Latency (s)"
set xlabel "Resource %"
set yrange [0:*]
set ytics 5
# high
set xrange [0:110]
set xtics 0,10,100
set style line 1 lc rgb '#0060ad' lt 1 lw 2 pt 5 ps 1.5   # blue
set style line 2 lc rgb '#dd181f' lt 1 lw 2 pt 7 ps 1.5   # red

ntics = 5

# stats 'data.dat' using 1 name 'x' nooutput


# set xtics x_max/ntics


do for [file in system("ls /home/ub-11/mitali/profiling/vgpu-1/solo/latency/*.csv | sed -e 's/\.csv$//' | xargs -n 1 basename")]{
    
    set output '/home/ub-11/mitali/plots/vgpu-1/solo/latency/'.file.".eps"
    stats '/home/ub-11/mitali/profiling/vgpu-1/solo/latency/'.file.".csv" using 2 name 'y' nooutput
    set ytics ceil(y_max/ntics)
    plot '/home/ub-11/mitali/profiling/vgpu-1/solo/latency/'.file.".csv" using ($1):($2) smooth unique w lp ls 1 title ""
    
    # replot
}