int: n; % number of nodes
set of int: NODE = 1..n;
int: m; % number of edges
set of int: EDGE = 1..m;
array[EDGE] of NODE: from;
array[EDGE] of NODE: to;
int: maxsteps; % maximum number of steps
set of int: TIME = 0..maxsteps;

NODE: start;
NODE: gold;

set of int: ACTION = 0..n+1;
ACTION: donothing = 0; % do nothing action = 0
ACTION: pickup = n+1;  % action n+1 is pickup gold
                       % otherwise its move to node i

%% decisions
var 1..maxsteps: steps;  % number of actions required
array[1..maxsteps] of var ACTION: act;

%% auxiliaries to hold state
array[TIME] of var NODE: position;
array[TIME] of var bool: holding;


predicate action(var int: current_position, var bool: current_holding,
                 var ACTION: next_action,
                 var int: next_position, var bool: next_holding) =
  if current_position = start /\ current_holding then
     next_position = current_position /\ next_action = donothing /\ next_holding = current_holding
  elseif current_position = gold /\ not current_holding then
     next_action = pickup /\ next_holding = true /\ next_position = current_position
  else
     exists (e in EDGE) (next_action = next_position /\ next_position = to[e] /\ from[e] = current_position /\ next_holding = current_holding)
  endif;

constraint forall (t in 1..maxsteps)
           ( action (position[t-1], holding[t-1], act[t], position[t], holding[t]) );

constraint position[0] = start /\ holding[0] = false;

constraint position[steps] = start /\ holding[steps];

solve :: int_search([steps], input_order, indomain_min, complete)
      minimize steps;



output [ if fix(act[t]) = donothing then 
            "nothing"
         else if fix(act[t]) = pickup then
            "pickup"
         else "move " ++ show(act[t]) endif endif
         ++ " "
       | t in 1..fix(steps) ]; 