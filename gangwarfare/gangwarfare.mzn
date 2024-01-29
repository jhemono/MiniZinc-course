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
int: nogang = n+1;
set of int: States = Gang union {nogang};
array [States, Student] of int: delta = array2d(States, Student,
  [ if s = n+1 then gang[m] elseif gang[m] in followable[s] then gang[m] else 0 endif | s in States, m in Student ]);

%%%%%%%

array [Time] of var Student: order;
array [Student] of var Time: passage;
array [Student] of var 0..3: points;

%%%%%%%

constraint inverse(order, passage);

constraint regular(order, card(States), card(Student), delta, nogang, Gang);

constraint forall (g in Gang where rivals[g] != {})
  ( let { Student: l = leader[g];
          var int: earliestRival = min([ latest[rival] | rival in rivals[g] ]);
          var bool: rivalBeforeLeader = passage[l] > earliestRival; } in
    points[l] = if rivalBeforeLeader \/ passage[l] < t div 2
                then 3
                else 0 endif /\
    forall (f in Student where gang[f] = g /\ f != l)
      ( points[f] = if passage[l] < passage[f]
                    then if rivalBeforeLeader
                         then 2
                         else 0 endif
                    else 1 endif ) );

constraint forall (g in Gang where rivals[g] = {})
  ( let { Student: l = leader[g]; } in
    points[l] = if passage[l] < t div 2
                then 3
                else 0 endif /\
    forall (f in Student where gang[f] = g /\ f != l)
      ( points[f] = if passage[l] < passage[f]
                    then 0
                    else 1 endif ) );

constraint obj = sum(points);

%%%%%%%

array [Gang] of var Time: latest;

%%%%%%%

constraint forall (g in Gang)
           ( maximum(latest[g], [ passage[s] | s in Student where gang[s] = g ]) );

%%%%%%%

% constraint forall (g in Gang where m[g] > 2)
%            ( increasing([ passage[s] | s in Student where gang[s] = g /\ s != leader[g] ]) );

%%%%%%%

constraint obj >= 72;

solve
% :: seq_search([
% Makes 29_44 find a 187 solution and all searches perform reasonably
%  int_search(points, dom_w_deg, indomain_max, complete),
%  int_search(order, dom_w_deg, indomain_min, complete)
% List of variable sets :
% Points of leaders
% Points of followers
% The last problem for which no solution is found : 31_41
%:: int_search(order, dom_w_deg, indomain_min, complete)
% int_search(points, max_regret, indomain_max, complete),
% int_search([points[leader[g]] | g in Gang], first_fail, indomain_max, complete),
%  int_search([passage[leader[g]] | g in Gang], first_fail, indomain_max, complete),
%  int_search(passage, dom_w_deg, indomain_random, complete)
% int_search([order[i] | i in Time where i mod 4 = 1], dom_w_deg, indomain_max, complete),
% int_search([order[i] | i in Time where i mod 4 = 2], dom_w_deg, indomain_min, complete),
% int_search([order[i] | i in Time where i mod 4 = 3], dom_w_deg, indomain_min, complete),
% int_search([order[i] | i in Time where i mod 4 = 0], dom_w_deg, indomain_max, complete),
%                ])
:: seq_search(let { int: md = 4; } in [ 
  int_search([order[i] | i in Time where i mod md = (ii mod md)], first_fail, if ii mod 2 = 0 then indomain_min else indomain_max endif, complete) | ii in 1..md])

 maximize obj;
% satisfy;


output ["order = ",show(order),
     ";\n  obj = ", show(obj),
%    ";\ngang= ", show(gang),
%    ";\nlead= ", show(leader),
%    ";\ntime= ", show(fix(passage)),
%    ";\npoin= ", show(fix(points)),
     ";\n" ];




