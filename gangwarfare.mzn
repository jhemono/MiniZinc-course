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

constraint forall (t in 2..t-1 where t mod 2 = 0) 
           ( let {var set of Gang: follow = followable[gang[order[t]]]; } in
             gang[order[t-1]] in follow /\ gang[order[t+1]] in follow );

constraint gang[order[t]] in followable[gang[order[t-1]]];

constraint forall (g in Gang)
  ( let { Student: l = leader[g]; } in
    if rivals[g] != {}
    then let {  var int: earliestRival     = min([ latest[rival] | rival in rivals[g] ]);
               var bool: rivalBeforeLeader = passage[l] > earliestRival; } in
         points[l] = if rivalBeforeLeader \/ passage[l] < t div 2
                     then 3
                     else 0 endif /\
         forall (f in Student where gang[f] = g /\ f != l)
         ( points[f] = if passage[l] < passage[f]
                       then if rivalBeforeLeader
                            then 2 else 0 endif
                       else 1 endif )
    else points[l] = if passage[l] < t div 2
                     then 3
                     else 0 endif /\
         forall (f in Student where gang[f] = g /\ f != l)
         ( points[f] = if passage[l] < passage[f]
                       then 0
                       else 1 endif )
    endif );

constraint obj = sum(points);

%%%%%%%

array [Gang] of var Time: latest;

%%%%%%%

constraint forall (g in Gang)
           ( maximum(latest[g], [ passage[s] | s in Student where gang[s] = g ]) );

%%%%%%%

constraint forall (g in Gang where m[g] > 2)
           ( increasing([ passage[s] | s in Student where gang[s] = g /\ s != leader[g] ]) );

%%%%%%%

solve
 :: seq_search([
% Makes 29_44 find a 187 solution and all searches perform reasonably
 int_search(points, dom_w_deg, indomain_max, complete),
 int_search(order, dom_w_deg, indomain_min, complete)
% List of variable sets :
% Points of leaders
% Points of followers
% The last problem for which no solution is found : 31_41
%:: int_search(order, dom_w_deg, indomain_min, complete)
               ])

 maximize obj;
% satisfy;


output ["order = ",show(order),
     ";\n  obj = ", show(obj),
%    ";\ngang= ", show(gang),
%    ";\nlead= ", show(leader),
%    ";\ntime= ", show(fix(passage)),
%    ";\npoin= ", show(fix(points)),
     ";\n" ];




