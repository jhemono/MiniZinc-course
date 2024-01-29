set term postscript font "sans,9"        # can set pdf as well 
set output '1_8.mzo.plt.ps'
set title "Pad & Machine Schedule for solution with obj value 439"
set autoscale
set xlabel 'Time' offset 0,-1.5
set ylabel 'Pad position'
set xtics out
set ytics out
unset colorbox
set border lw 0.5
set key outside above right horizontal
plot  '-' with boxxyerrorbars notitle  fill pattern border , '-' with boxxyerrorbars notitle  fill pattern border , '-' with boxxyerrorbars notitle  fill pattern border , '-' with boxxyerrorbars notitle lt -1 fill empty, '-' with labels font "12" offset 0.5,0.5 notitle , '-' with linespoints ls 2 lw 6 title 'R_1', '-' with linespoints ls 3 lw 6 title 'R_2', '-' with linespoints ls 4 lw 6 title 'R_3', '-' with linespoints ls 5 lw 6 title 'R_4'
# Dwell: putting first to have the empty fill pattern: x y xlow xhigh ylow yhigh (color?)
1 1 8 8 1 3
1 1 103 103 0 2
1 1 20 20 2 3
1 1 48 48 0 4
1 1 150 150 4 7
1 1 26 26 0 2
1 1 80 80 0 5
1 1 15 15 0 1
1 1 117 117 0 2
1 1 135 135 0 3
1 1 250 250 0 5
1 1 160 160 0 4
end
# Stacking: x y xlow xhigh ylow yhigh (color?)
1 1 0 8 1 3
1 1 95 103 0 2
1 1 16 20 2 3
1 1 32 48 0 4
1 1 138 150 4 7
1 1 18 26 0 2
1 1 60 80 0 5
1 1 11 15 0 1
1 1 109 117 0 2
1 1 123 135 0 3
1 1 230 250 0 5
1 1 144 160 0 4
end
# Reclaim: x y xlow xhigh ylow yhigh (color?)
1 1 8 14 1 3
1 1 103 109 0 2
1 1 20 23 2 3
1 1 48 60 0 4
1 1 150 159 4 7
1 1 26 32 0 2
1 1 80 95 0 5
1 1 15 18 0 1
1 1 117 123 0 2
1 1 135 144 0 3
1 1 250 265 0 5
1 1 160 172 0 4
end
# Whole boxes: x y xlow xhigh ylow yhigh (color?)
1 1 0 14 1 3 1
1 1 95 109 0 2 2
1 1 16 23 2 3 3
1 1 32 60 0 4 4
1 1 138 159 4 7 5
1 1 18 32 0 2 6
1 1 60 95 0 5 7
1 1 11 18 0 1 8
1 1 109 123 0 2 9
1 1 123 144 0 3 10
1 1 230 265 0 5 11
1 1 144 172 0 4 12
end
# Labels: x y text (rgbcolor)
8 2 1
103 1 2
20 2 3
48 2 4
150 5 5
26 1 6
80 2 7
15 0 8
117 1 9
135 1 10
250 2 11
160 2 12
end
 # Recl schedule: x y 
8 1
14 1
15 0
18 0
26 0
32 0
103 0
109 0
117 0
123 0
160 0
172 0
end
 # Recl schedule: x y 
20 2
23 2
48 0
60 0
80 0
95 0
135 0
144 0
end
 # Recl schedule: x y 
150 4
159 4
end
 # Recl schedule: x y 
250 0
265 0
end
set title "\n\n\n\nThe input data: obj value 439 and:\n\n\neastend = [3, 2, 3, 4, 7, 2, 5, 1, 2, 3, 5, 4];\nendstack = [8, 103, 20, 48, 150, 26, 80, 15, 117, 135, 250, 160];\nfinish = [14, 109, 23, 60, 159, 32, 95, 18, 123, 144, 265, 172];\nreclaim = [8, 103, 20, 48, 150, 26, 80, 15, 117, 135, 250, 160];\nstack = [0, 95, 16, 32, 138, 18, 60, 11, 109, 123, 230, 144];\nwestend = [1, 0, 2, 0, 4, 0, 0, 0, 0, 0, 0, 0];\nwhich = [1, 1, 2, 2, 3, 1, 2, 1, 1, 2, 4, 1];\n" font "sans,12"
set yrange[-1:0]
unset ytics; unset xtics; unset border
plot x*x notitle

