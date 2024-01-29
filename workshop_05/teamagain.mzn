include "globals.mzn";

int: n;
set of int: People = 1..n;
int: m;
set of int: Captains = 1..m;

array [Captains,People] of int: value;

array [People] of var Captains: teams;

% constraint global_cardinality_low_up_closed
%            (teams, Captains, [ n div m | c in Captains], [ (n div m) + 1 | c in Captains]);

array [Captains] of var 1..n: size = global_cardinality(teams, Captains);

constraint forall (c1, c2 in Captains where c1 < c2)
          ( abs(size[c1] - size[c2]) <= 1 );

% array [Captains] of var set of People: truc;

% constraint int_set_channel(teams, truc);

var int: obj = sum (p in People) ( value[teams[p],p] );

solve maximize obj;

output ["obj = \(obj)\nteams = \(teams)\nsizes = \(size)\n"];