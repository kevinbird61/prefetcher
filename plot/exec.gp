reset
set xlabel "第幾次執行次數"
set ylabel "time(us)"
set title "execution time"
set term png enhanced font 'Consolas,10'
set output 'runtime.png'

plot "sse.txt" using 1 with linespoints title "sse prefetch" , \
     "sse.txt" using 2 with linespoints title "sse", \
     "sse.txt" using 3 with linespoints title "naive"
