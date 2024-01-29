int: f;
int: g;
int: c;

array [Items] of int: starts = [f,g,c];
int: maxitem = max(starts);

int: k;
set of int: Cap = 0..k;
int: t;
set of int: Trips = 1..t;
int: pf;
int: pg;
int: pc;

array [Items] of int: prices = [pf,pg,pc];

array [Trips,Items] of var Cap: aboard;

constraint forall (t in Trips, i in Items)
           ( aboard[t,i] <= min(k, starts[i]));

var 0..t: trips;

var int: obj;

%%%%%%%%%%%%%%%%%%%%%%%%%%% ADD constraints in here %%%%%%%%%%%%%

constraint forall (t in Trips)
           ( sum (i in Items) ( aboard[t,i] ) <= k );

set of int: States = Trips union {0};

int: west = 0;
int: east = 1;
set of int: Banks = {west, east};

int: fox = 1;
int: geese = 2;
int: corn = 3;
set of int: Items = {fox,geese,corn};

array [States,Banks,Items] of var 0..maxitem: state;

constraint forall (t in States, b in Banks, i in Items)
           ( state[t,b,i] <= starts[i] );

constraint forall (i in Items)
           ( state[0,west,i] = starts[i] /\ state[0,east,i] = 0);

constraint trips mod 2 = east; % The farmer ends up on the east bank

constraint obj = sum (i in Items) ( state[trips,east,i] * prices[i] );

constraint forall (t in Trips, i in Items where t <= trips) % 3
           ( state[t,(t mod 2),i] = state[t-1,(t mod 2),i] + aboard[t,i] );

predicate update (array [Items] of var int: new,
                  array [Items] of var int: leaving,
                  array [Items] of var int: change) =
          forall (i in Items)
                 ( new[i] = leaving[i] - change[i] );

constraint forall (t in Trips where t <= trips)
           ( let { array [Items] of var int: new = [ state[t,((t+1) mod 2),i] | i in Items ];
                   array [Items] of var int: leaving = [state[t-1,((t+1) mod 2),i] - aboard[t,i] | i in Items] }
             in if leaving[fox] > 0 /\ leaving[corn] > 0 /\ leaving[geese] = 0 then 
                   update (new, leaving, [1,0,1])
                elseif leaving[fox] > 0 /\ leaving[geese] > 0 then
                   if leaving[fox] > leaving[geese] then
                      update (new, leaving, [1,0,0])
                   else
                      update (new, leaving, [0,leaving[fox],0]) endif
                elseif leaving[fox] = 0 /\ leaving[geese] > 0 /\ leaving[corn] > 0 then
                   if leaving[geese] <= leaving[corn] then
                      update (new, leaving, [0,0,leaving[geese]])
                   else
                      update (new, leaving, [0,1,1]) endif
                else update (new, leaving, [0,0,0]) endif );

constraint forall (t in Trips, i in Items where t > trips)
           ( aboard[t,i] = 0 /\ forall (b in Banks) ( state[t,b,i] = 0 ) );

%%%%%%%%%%%%%%%%% you may want to modify the search strategy below

solve :: seq_search([int_search([trips], input_order, indomain_min, complete),
                     int_search([aboard[t,i] | t in Trips, i in Items ], input_order, indomain_max, complete)]) maximize obj;


output ["  fox = ", show([aboard[t,fox] | t in Trips]),
     ";\ngeese = ", show([aboard[t,geese] | t in Trips]),
     ";\n corn = ", show([aboard[t,corn] | t in Trips]),
     ";\ntrips = ", show(trips), 
     ";\n  obj = ", show(obj), ";\n"]
%      ++
%        ["easts = ", show([state[t,east,i] | t in States, i in Items ]),
%      ";\nwests = ", show([state[t,west,i] | t in States, i in Items ]),
%      ";\nboats = ", show(aboard)]
     ;

