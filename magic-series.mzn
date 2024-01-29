%Magic series

int: N = 7;
array [0..N-1] of var 0..N: number;

constraint forall (i in 0..N-1) ( sum (j in 0..N-1) (bool2int(number[j] = i)) = number[i] );

solve satisfy;

output [ show(number[i]) ++ " " | i in 0..N-1 ];