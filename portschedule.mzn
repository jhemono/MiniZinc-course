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

array [STOCKPILE] of var TIME: duration;
array [STOCKPILE] of var TIME: finished;
array [STOCKPILE] of var TIME: endstack;
array [STOCKPILE] of var POSITION: eastend = [ westend[s] + size[s] | s in STOCKPILE ];

%%%%%%

array [STOCKPILE] of TIME: reclaim_duration = [size[s] * reclaim_time | s in STOCKPILE];
array [STOCKPILE] of TIME: stack_duration = [ size[s] * stack_time | s in STOCKPILE];
array [STOCKPILE] of TIME: min_duration = [ reclaim_duration[s] + stack_duration[s] | s in STOCKPILE ];

%%%%%% Stage A

constraint forall (s in STOCKPILE)
           ( stack[s] + stack_duration[s] = endstack[s] );

constraint forall (s in STOCKPILE)
           ( endstack[s] <= reclaim[s] );

constraint forall (s in STOCKPILE)
           ( reclaim[s] + reclaim_duration[s] = finished[s] );

constraint forall (s in STOCKPILE)
           ( stack[s] + duration[s] = finished[s] );

constraint diffn(westend, stack, size, duration);

%%%%%%

constraint forall (s in STOCKPILE)
  ( westend[s] + size[s] <= len);

constraint forall (s in STOCKPILE)
  ( stack[s] + min_duration[s] <= maxtime );

constraint forall (s in STOCKPILE)
  ( reclaim[s] + reclaim_duration[s] <= maxtime );

constraint forall (s in STOCKPILE)
  ( min_duration[s] <= finished[s] );

constraint forall (s in STOCKPILE)
  ( endstack[s] + reclaim_duration[s] <= maxtime );

%%%%%% Stage B % Replaced by Stage D

% constraint forall (r in RECLAIMER)
%   ( cumulative(reclaim, reclaim_duration, [ bool2int(which[s] = r) | s in STOCKPILE ], 1) );

%%%%%% Stage C

constraint forall (s in STOCKPILE)
  ( reclaim[s] >= arrival[ship[s]] );

constraint forall (sh in SHIP)
  ( cumulative([ reclaim[s] | s in STOCKPILE where ship[s] = sh ],
               [ reclaim_duration[s] | s in STOCKPILE where ship[s] = sh ],
               [ 1 | s in STOCKPILE where ship[s] = sh],
               1) );

%%%%%% Stage D

set of int: STOCKE = 1..ns+nr;
array [STOCKE] of var STOCKE: next;
array [STOCKE] of var RECLAIMER: whiche;
array [STOCKE] of var TIME: reclaime;
array [STOCKE] of var POSITION: westende;


constraint forall (s in STOCKPILE)
  ( reclaime[s] = reclaim[s] /\ westende[s] = westend[s] );

constraint alldifferent(next);

constraint forall (s in STOCKPILE)
  ( whiche[s] = whiche[next[s]] );

constraint forall (r in RECLAIMER)
  ( whiche[ns + r] = r );

constraint forall (s in STOCKPILE)
  ( which[s] = whiche[s] );

constraint forall (s in STOCKPILE)
  ( reclaime[next[s]] >= finished[s] + (abs(westende[next[s]] - westende[s]) * reclaim_speed) );

%%%%%%

var TIME: makespan = max(finished);

%%%%%%

% solve 
% :: seq_search([
%     int_search([makespan], input_order, indomain_min, complete),
%    int_search(stack, dom_w_deg, indomain_max, complete),
% ]) minimize makespan;

solve
:: int_search([ reclaim[s] - endstack[s] | s in STOCKPILE ], input_order, indomain_min, complete) minimize makespan;

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
