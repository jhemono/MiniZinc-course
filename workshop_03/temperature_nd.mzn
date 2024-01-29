array[int] of int: readings;
int: start;

set of int: ECH = index_set(readings);

array [ECH] of var int: indoor;

constraint forall (i in ECH where i+1 in ECH)
           ( (readings[i] + indoor[i]) div 2 = indoor[i+1] );

constraint indoor[min(ECH)] = start;

solve satisfy;