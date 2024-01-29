% Minizinc rocks

include "alldifferent.mzn";

var 1..9: M;
var 0..9: I;
var 0..9: N;
var 1..5: Z;
var 0..9: C;
var 1..9: R;
var 0..9: O;
var 0..9: K;

constraint alldifferent([M,I,N,Z,C,R,O,K]);

constraint  M*1000 + I*100 + N*10 + I
          + Z*1000 + I*100 + N*10 + C 
= R*10000 + O*1000 + C*100 + K*10 + Z;

solve satisfy;