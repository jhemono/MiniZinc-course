var 0..9: S;
var 0..9: E;
var 0..9: N;
var 0..9: D;
var 0..9: M;
var 0..9: O;
var 0..9: T;
var 0..9: Y;

include "alldifferent.mzn";

constraint alldifferent([S,E,N,D,M,O,T,Y]);

constraint   S*1000 + E*100 + N*10 + D
           + M*1000 + O*100 + S*10 + T
 = M*10000 + O*1000 + N*100 + E*10 + Y;

solve maximize M*10000 + O*1000 + N*100 + E*10 + Y;