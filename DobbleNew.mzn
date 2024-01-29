%Dobble with array-encodes fixed-cardinality sets

include "globals.mzn";

int: n = 31;
int: k = 6;

set of int: Symbols = 1..n;
set of int: Card = 1..k;

array [Symbols, Card] of var Symbols: distri;

constraint forall (s in Symbols, c in 1..k-1)
           ( distri[s,c] < distri[s,c+1] );

constraint forall (s1, s2 in Symbols where s1 < s2)
           ( sum (c1 in Card) ( exists (c2 in Card) ( distri[s1,c1] = distri[s2,c2] ) ) = 1 );

solve satisfy;

output [show([distri[s,c] | c in Card]) ++ "\n" | s in Symbols ];