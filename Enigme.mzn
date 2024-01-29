array [1..4] of var int: total;

constraint forall (m in 1..4)
           ( total[m] = sum (n in 1..4) (total[n] = m) + 1 );

solve satisfy;