set term postscript eps background rgb 'white' color 'Verdana,30' size 7,7
# set output '/home/ub-11/mitali/plots/resent50_pytorch/ubench_vgg16_tf.eps'
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
set ytics (0,10,30,50,70,100)
# high
# set xrange [8:16]
# set xrange [8:16]

# ntics = 5

# stats 'data.dat' using 1 name 'x' nooutput


# set xtics x_max/ntics
set output '/home/ub-11/mitali/plots/solo/gpu_util/vgg16_tf.eps'

# do for [file in system("ls /home/ub-11/mitali/profiling/solo/gpu_util_mod/vgg16_tf/*.csv | sed -e 's/\.csv$//' | xargs -n 1 basename")]{
    
    
#     # stats '/home/ub-11/mitali/profiling/solo/gpu_util_mod/vgg16_tf/'.file.".csv" using 2 name 'y' nooutput
#     # set ytics ceil(y_max/ntics)
#     plot '/home/ub-11/mitali/profiling/solo/gpu_util_mod/vgg16_tf/'.file.".csv" using ($1/1000000000):($2) with lines
    
#     # replot
# }
plot for [file in system("ls /home/ub-11/mitali/profiling/solo/gpu_util_mod/vgg16_tf/*.csv | sed -e 's/\.csv$//' | xargs -n 1 basename")] '/home/ub-11/mitali/profiling/solo/gpu_util_mod/vgg16_tf/'.file.".csv" using ($1/1000000000):($2) with lines title file