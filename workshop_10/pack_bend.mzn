int: n; % number of bends
set of int: BEND = 1..n;

array [BEND] of int: fst;
array [BEND] of int: snd;

int: hgt;
int: len;

array [BEND] of var 0..len: x;
array [BEND] of var 0..hgt: y;

include "globals.mzn";

constraint diffn(x                 ++ x,
                 y                 ++ [ y[b] + 1 | b in BEND ],
                 fst               ++ [ 1 | b in BEND ],
                 [ 1 | b in BEND ] ++ snd);

constraint forall (b in BEND)
  ( x[b] + fst[b] <= len /\ y[b] + 1 + snd[b] <= hgt );

var max(fst)..len: obj = max(b in BEND) (x[b] + fst[b]);

solve minimize obj;