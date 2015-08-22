int: nr; % number of reclaimers
         % number of rails = nr for stages A,B,C,D,E
         % number of rails = (nr + 1) div 2 for stage F
set of int: RECLAIMER = 1..nr;
bool: stageF; % is this stage F data

int: ns; % number of stockpiles
set of int: STOCKPILE = 1..ns;
array[STOCKPILE] of int: size; % size in 10000 tonnes
array[STOCKPILE] of SHIP: ship; % which ship carries stockpile

constraint forall(sh in SHIP)
                 (assert(exists(s in STOCKPILE)(ship[s] = sh),
                 "Ship " ++ show(sh) ++ " has no cargo!"));
 
int: maxtime; % time considered
set of int: TIME = 0..maxtime;

int: nsh; % number of ships
set of int: SHIP = 1..nsh;
array[SHIP] of TIME: arrival; % when ship arrives in port

int: len; % length of pad
set of int: POSITION = 0..len;

int: stack_time;
int: reclaim_time;
int: reclaim_speed;

array[STOCKPILE] of var POSITION: westend;
array[STOCKPILE] of var TIME: stack;
array[STOCKPILE] of var TIME: reclaim;
array[STOCKPILE] of var RECLAIMER: which;

%%%%%%

include "globals.mzn";

%%%%%%

array [STOCKPILE] of var TIME: onPad;
array [STOCKPILE] of var TIME: finished = [ stack[s] + onPad[s] | s in STOCKPILE ];
array [STOCKPILE] of var TIME: endstack = [ stack[s] + (stack_time * size[s]) | s in STOCKPILE ];
array [STOCKPILE] of var POSITION: eastend = [ westend[s] + size[s] | s in STOCKPILE ];

%%%%%%

constraint forall (s in STOCKPILE)
           ( onPad[s] >= size[s] * (stack_time + reclaim_time) );

constraint forall (s in STOCKPILE)
           ( reclaim[s] = stack[s] + onPad[s] - (reclaim_time * size[s]) );

constraint diffn(westend, stack, size, onPad);

%%%%%%

constraint forall (r in RECLAIMER) ( disjunctive(, [size[s] * reclaim_time | s in STOCKPILE]) );

%%%%%%

%%%%%%

solve satisfy;

%%%%%%

output 
["westend  = ", show(westend), ";\n"] ++
["eastend  = ", show(eastend), ";\n"] ++
["stack    = ", show(stack), ";\n"] ++
["endstack = ", show(endstack), ";\n"] ++
["reclaim  = ", show(reclaim), ";\n"] ++
["finish   = ", show(finished) , ";\n"] ++
["which    = ", show(which), ";\n"]
;
