% Dobble Check

set of int: Cards = 0..56;
set of int: Symbols = 0..7;

array [Cards, Symbols] of var Cards: cards;
array [Cards] of var set of Cards: sets;

include "Input.mzn";

constraint forall (c in Cards, s in Symbols)
           ( cards[c,s] in sets[c] );

constraint forall (c in Cards)
           ( card(sets[c]) = 8 );

% Validity Check

constraint forall (c1 in Cards, c2 in Cards where c1 < c2)
           ( card(sets[c1] intersect sets[c2]) = 1 );

constraint forall (s1 in Cards, s2 in Cards where s1 < s2)
           ( exists (c in Cards)
             ( s1 in sets[c] /\ s2 in sets[c] ) );

solve satisfy;