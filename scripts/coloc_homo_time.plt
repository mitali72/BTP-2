set term postscript eps background rgb 'white' color 'Verdana,30' size 6,5
# set output '/home/ub-11/mitali/plots/video_recog_tf/ubench_video_recog_tf.eps'
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
# set rmargin 15
# set key at screen 1, graph 1
set key top
set ylabel "Latency (s)"
set xlabel "Total number of processes"
set yrange [0:*]
# set ytics 5
# set format y "%.2f"
# high
# set xrange [1:*]
# set xtics 0,4,44
set style line 1 lt 1 lw 2 pt 5 ps 1.5 lc rgb '#0060ad'  # blue
set style line 2 lt 1 lw 2 pt 7 ps 1.5 lc rgb '#dd181f' # red
set style line 3 lt 1 lw 2 pt 5 ps 1.5 lc rgb '#00ad11' # green

ntics = 4

# stats 'data.dat' using 1 name 'x' nooutput


# set xtics x_max/ntics


# do for [file in system("ls /home/ub-11/mitali/profiling/coloc_homo/*.csv | sed -e 's/\.csv$//' | xargs -n 1 basename")]{
    
#     set output '/home/ub-11/mitali/plots/coloc_homo/'.file.".eps"
#     stats '/home/ub-11/mitali/profiling/coloc_homo/'.file.".csv" using (floor(($1/$2)*1e2)/1e2) name 'y' nooutput
#     set ytics y_max/ntics
#     plot '/home/ub-11/mitali/profiling/coloc_homo/'.file.".csv" using ($1):($1/$2) w lp ls 1 title ""
    
#     # replot
# }
LINECOLORS = "red  green blue  magenta cyan"
myLinecolor(i) = word(LINECOLORS,i)

set output '~/mitali/plots/coloc_homo/latency/video_recog_tf.eps'

# stats '~/mitali/profiling/coloc_homo/video_recog_tf/latency/1vgpu.csv' using (floor(($2)*1e2)/1e2) name 'y' nooutput
# set ytics floor(y_max/ntics)

# plot '~/mitali/profiling/coloc_homo/video_recog_tf/latency/1vgpu.csv' using ($1):($2) w lp ls 1 title '1 vgpu',\
#   '~/mitali/profiling/coloc_homo/video_recog_tf/latency/mps_1vgpu.csv' using ($1):($2) w lp ls 2 title '1 vgpu mps',\
#   '~/mitali/profiling/coloc_homo/video_recog_tf/latency/mps_4vgpu.csv' using ($1):($3) w lp ls 3 title '4 vgpu mps'

set xtics 1
stats '~/mitali/profiling/coloc_homo/video_recog_tf/latency/mps_4vgpu.csv' using (floor(($3)*1e2)/1e2) name 'y' nooutput
set ytics floor(y_max/ntics)
plot '~/mitali/profiling/coloc_homo/video_recog_tf/latency/mps_4vgpu.csv' using ($1):($3) w lp ls 1 title '4 vgpu mps'


# plot '~/mitali/profiling/coloc_homo/latency/video_recog_tf/1vgpu.csv' using ($1):($1/$2) w lp ls 1 title '1 vgpu',\
#   '~/mitali/profiling/coloc_homo/latency/video_recog_tf/mps_1vgpu.csv' using ($1):($1/$2) w lp ls 2 title '1 vgpu mps'
#   '~/mitali/profiling/coloc_homo/latency/video_recog_tf/mps_4vgpu.csv' using ($1):($1/$2) w lp ls 3 title '4 vgpu mps'


# plot for [file in system("ls ~/mitali/profiling/coloc_homo/latency/video_recog_tf/*.csv | sed -e 's/\.csv$//' | xargs -n 1 basename")] '~/mitali/profiling/coloc_homo/latency/video_recog_tf/'.file.".csv" using ($1):($1/$2) with lp lt 1 lw 2 pt 5 ps 1.5 title file