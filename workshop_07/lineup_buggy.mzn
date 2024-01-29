include "globals.mzn";

% lineup
% place k persons in a line with gaps
% no two people of the same gender adjacent
% maximize the sum of differences in height of adjacent people
int: k;
set of int: PERSON = 1..k;
int: empty = 0;
set of int: PERSON0 = 0..k;

int: male = 1; int: female = 2;
set of int: GENDER = male..female;
array[PERSON] of GENDER: sex;

array[PERSON] of int: height;

int: n = k+3;
set of int: POSN = 1..n;

array[PERSON] of var POSN:  place;
array[POSN] of var PERSON0: who;

% symmetry breaking: This constraint is guaranteed to be correct
% Make sure someone is in the first position, 
% If there are two empty positions in a row this has to happen at the end. 
constraint who[1] != empty /\ forall(i in 1..n-1)(who[i] = empty /\ who[i+1] = empty -> forall(j in i..n)(who[j] = empty));


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% ALL MODELLING ERRORS ARE BELOW THIS LINE %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

constraint forall(i in PERSON, j in POSN)(place[i] = j <-> who[j] = i);

constraint alldifferent_except_0(who);

constraint forall(p1, p2 in PERSON where p1 < p2)(sex[p1] = sex[p2] -> abs(place[p1] - place[p2]) > 1);

var int: obj = sum(p in 1..n-1)(if who[p] > 0 /\ who[p+1] > 0 then abs(height[who[p]] - height[who[p+1]]) else 0 endif);

solve maximize obj;

output [show(obj),": ",show(who)];
