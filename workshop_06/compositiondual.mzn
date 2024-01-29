int: n = 15;
set of int: Notes = 1..n;
set of int: Positions = 1..n;

array [Positions] of var Notes: order;
array [Notes] of var Positions: pos; 

array [1..n-1] of var 1..n-1: differences = [ abs(order[p] - order[p+1]) | p in 1..n-1 ];
array [1..n-1] of var 1..n-1: dpos;

include "globals.mzn";

constraint abs(pos[1]-pos[n]) = 1;
constraint dpos[n-1] = min(pos[1], pos[n]);

constraint inverse(order,pos);
constraint inverse(differences,dpos);

solve satisfy;

output [ show_int(4,order[p]) | p in Positions ] ++
       ["\n "] ++
       [ show_int(4,differences[i]) | i in 1..n-1 ];