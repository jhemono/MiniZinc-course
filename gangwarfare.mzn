int: n;                 % number of gangs
set of int: Gang = 1..n; 
array[Gang] of int: m;  % size of each gang
int: t = sum(i in Gang)(m[i]);
set of int: Time = 1..t;
set of int: Student = 1..t;
int: r; % number of rivalries
set of int: Rival = 1..r;
array[Rival] of Gang: g1;
array[Rival] of Gang: g2;
var int: obj;

%%%%%%%

include "globals.mzn";

%%%%%%%

array [Student] of Gang: gang = [ g | g in Gang, c in 1..m[g] ];
array [Gang] of Student: leader = [ sum (pg in Gang) ( if pg < g then m[pg] else 0 endif ) + 1 | g in Gang ];
array [Gang] of set of Gang: rivals =
    [ { g2[k] | k in Rival where g1[k] = g } union { g1[k] | k in Rival where g2[k] = g } | g in Gang ];
array [Gang] of set of Gang: followable = [ Gang diff ({g} union rivals[g]) | g in Gang ];

%%%%%%%

array [Time] of var Student: order;
array [Student] of var Time: passage;
array [Student] of var 0..3: points;

%%%%%%%

constraint inverse(order, passage);

constraint forall (t in 1..t-1) ( gang[order[t]] in followable[gang[order[t+1]]] );

constraint forall (s in Student)
           ( points[s] =
               if s = leader[gang[s]]
               then if gang[s] in hasRivals
                    then if leaderBeforeRival[gang[s]] \/ passage[s] < t div 2
                         then 3
                         else 0 endif
                    else if passage[s] < t div 2
                         then 3
                         else 0 endif endif
               else if passage[s] > passage[leader[gang[s]]]
                    then if gang[s] in hasRivals
                         then if leaderBeforeRival[gang[s]]
                              then 2
                              else 0 endif
                         else 0 endif
                    else 1 endif endif );

constraint obj = sum(points);

%%%%%%%

set of Gang: hasRivals = { g | g in Gang where rivals[g] != {} };

%%%%%%%

array [Gang] of var Time: latest;
array [hasRivals] of var bool: leaderBeforeRival;

%%%%%%%

constraint forall (g in Gang)
           ( maximum(latest[g], [ passage[s] | s in Student where gang[s] = g ]) );

constraint forall (g in hasRivals)
           ( let { var int: earliestRival = min([ latest[rival] | rival in rivals[g] ]); } in
             leaderBeforeRival[g] = (earliestRival < passage[leader[g]]) );

%%%%%%%

constraint forall (g in Gang where m[g] > 2)
           ( increasing([ passage[s] | s in Student where gang[s] = g /\ s != leader[g] ]) );

%%%%%%%

solve
                    % :: int_search([ points[l] | l in leader ], first_fail, indomain_max, complete),
                    % :: int_search([ passage[l] | l in leader ], first_fail, indomain_min, complete),
                    % :: int_search(order, first_fail, indomain_max, complete)
                    % :: int_search(points, dom_w_deg, indomain_max, complete) % actually good maybe combine with bast on other var ?
                    % :: seq_search([
                         % int_search(points, dom_w_deg, indomain_max, complete)
                         %,int_search(order, dom_w_deg, indomain_median, complete)
                         %,int_search(order, first_fail, indomain_reverse_split, complete)
                         %,int_search(order, first_fail, indomain_min, complete)
                         % int_search(points, largest, indomain_max, complete)
                         %,int_search(order, first_fail, indomain_split, complete)
                         %          ])

 :: seq_search([
% int_search(points, dom_w_deg, indomain_max, complete)
% int_search(points,input_order,indomain_max,complete)
% Makes 29_44 find a 187 solution
int_search(points, dom_w_deg, indomain_max, complete),
int_search(order, dom_w_deg, indomain_min, complete)
% List of variable sets :
% Points of leaders
% Points of followers
               ])

 maximize obj;
% satisfy;


output ["order = ",show(order),
   ";\n  obj = ", show(obj),
   ";\ngang= ", show(gang),
   ";\nlead= ", show(leader),
   ";\ntime= ", show(fix(passage)),
   ";\npoin= ", show(fix(points)),
     ";\n" ];




