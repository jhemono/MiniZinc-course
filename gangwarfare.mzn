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

%%%%%%%

array [Time] of var Student: order;
array [Student] of var Time: passage;
array [Student] of var {0,1,3}: points;

%%%%%%%

constraint inverse(order, passage);

constraint forall (t in 1..t-1) ( gang[order[t]] != gang[order[t+1]] );

constraint forall (s in Student)
           ( points[s] =
               if s = leader[gang[s]]
               then if passage[s] < t div 2
                    then 3
                    else 0 endif
               else if passage[s] > passage[leader[gang[s]]]
                    then 0
                    else 1 endif endif );

constraint obj = sum(points);

%%%%%%%

solve ::seq_search([
                    int_search([ points[l] | l in leader ], first_fail, indomain_max, complete),
                    %int_search([ passage[l] | l in leader ], first_fail, indomain_min, complete),
                    %int_search(order, first_fail, indomain_max, complete)
                   ])
maximize obj;


output ["order = ",show(order),
	";\nobj = ", show(obj),
%   ";\ngang= ", show(gang),
%   ";\nlead= ", show(leader),
%   ";\ntime= ", show(passage),
%   ";\npoin= ", show(points),
	";\n" ];




