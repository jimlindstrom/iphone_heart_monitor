set term png size 1300,700
set output "deltas.png"
plot \
     "deltas.csv" using 0:2 with lines
