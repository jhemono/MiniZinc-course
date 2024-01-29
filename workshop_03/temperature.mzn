array[int] of int: readings;
int: start;

set of int: ECH = index_set(readings);
set of int: ECHP = ECH union {max(ECH)+1};

array [ECHP] of var 16..22: indoor;

set of int: ACT = 1..5;

array [ACT] of int: effect = [-5, -2, 0, 1, 4];
array [ACT] of int: cost  = [90, 30, 0, 10, 50];

array [ECH] of var ACT: commands;

constraint forall (i in ECH)
           ( ((readings[i] + indoor[i]) div 2) + effect[commands[i]] = indoor[i+1] );

constraint indoor[min(ECH)] = start;

var int: total_cost = sum (i in ECH) ( cost[commands[i]] );

solve minimize total_cost;

int: digits = 4;

output ["Hour:   "] ++ [show_int(digits,h) | h in ECHP] ++
       ["\nOutside:"] ++ [show_int(digits,readings[h]) | h in ECH] ++
       ["\nAction: "] ++ [show_int(digits, effect[commands[h]]) | h in ECH ] ++
       ["\nInside: "] ++ [show_int(digits, indoor[h]) | h in ECHP] ++
       ["\nTotal Cost: ", show_int(digits, total_cost)];
       