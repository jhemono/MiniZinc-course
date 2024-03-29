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
           ( endstack[s] = reclaim[s] );

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

constraint forall (sh in SHIP where sum(s in STOCKPILE) (ship[s] = sh) > 1)
  ( cumulative([ reclaim[s] | s in STOCKPILE where ship[s] = sh ],
               [ reclaim_duration[s] | s in STOCKPILE where ship[s] = sh ],
               [ 1 | s in STOCKPILE where ship[s] = sh],
               1) );

%%%%%% Stage D

set of int: STOCKE = 1..ns+nr;
array [STOCKE] of STOCKE: order = arg_sort([ if sd > ns then max(arrival) + 1 else arrival[ship[sd]] endif | sd in STOCKE ]);
array [STOCKE] of var STOCKE: next;
array [STOCKE] of var RECLAIMER: whiche;
array [STOCKE] of var TIME: reclaime;
array [STOCKE] of var POSITION: westende;


constraint forall (s in STOCKPILE)
  ( let { int: ss = order[s]; } in % works because dummies at the end, should use the inverse of order
    reclaime[s] = reclaim[ss] /\ westende[s] = westend[ss] /\ whiche[s] = which[ss] );

constraint alldifferent(next);

constraint forall (s in STOCKE)
  ( whiche[s] = whiche[next[s]] );

constraint forall (r in RECLAIMER)
  ( whiche[ns + r] = r );

constraint forall (s in STOCKPILE)
  ( reclaime[next[s]] >= finished[s] + (abs(westende[next[s]] - westende[s]) * reclaim_speed) );

%%%%%% Stage E

array [SHIP] of var TIME: berth_time;

constraint forall (sh in SHIP)
  ( arrival[sh] + berth_time[sh] = max(s in STOCKPILE where ship[s] = sh) ( finished[s] ) );

var int: obj = sum(berth_time);

%%%%%%

constraint forall (sh in SHIP)
  ( berth_time[sh] >= sum(s in STOCKPILE where ship[s] = sh) ( reclaim_duration[s] ) );

constraint obj >= sum(reclaim_duration);

%%%%%%

% solve 
% :: seq_search([
%     int_search([makespan], input_order, indomain_min, complete),
%    int_search(stack, dom_w_deg, indomain_max, complete),
% ]) minimize makespan;

%%%%%%

array [STOCKE] of var 1..(ns+nr-1): nextForSearch;

constraint forall (sd in STOCKE)
  ( nextForSearch[sd] = ((next[sd] - sd + (ns + nr)) mod (ns + nr)) );

solve
:: seq_search([
%int_search([ reclaim[s] - endstack[s] | s in STOCKPILE ], input_order, indomain_min, complete),
% int_search(westend, first_fail, indomain_random, complete),
% int_search(reclaim, dom_w_deg, indomain_min, complete),
% int_search(berth_time, dom_w_deg, indomain_min, complete),
% int_search(next, first_fail, indomain_random, complete),
int_search(nextForSearch, input_order, indomain_min, complete),
int_search(westend ++ reclaim, dom_w_deg, indomain_min, complete),
]) minimize obj;

%%%%%%

output 
["westend  = ", show(westend), ";\n"] ++
["eastend  = ", show(eastend), ";\n"] ++
["stack    = ", show(stack), ";\n"] ++
["endstack = ", show(endstack), ";\n"] ++
["reclaim  = ", show(reclaim), ";\n"] ++
["finish   = ", show(finished) , ";\n"] ++
["which    = ", show(which), ";\n"]
++
["obj      = ", show(obj), ";\n"] ++
["next     = ", show(next), ";\n"]
;
