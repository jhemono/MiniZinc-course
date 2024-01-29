% Dobble with heaps

include "partition_set.mzn";

int: nbSymbolsCard = 6;
int: nbHeaps = nbSymbolsCard;
int: nbCardsHeap = nbSymbolsCard - 1;
set of int: rangeOfMaster = 1..nbSymbolsCard;
set of int: rangeOfSymbols = 1..nbSymbols;
set of int: rangeOfHeap = rangeOfSymbols diff rangeOfMaster;
int: nbSymbols = nbSymbolsCard + nbCardsHeap * (nbHeaps - 1);
int: nbCards = 1 + nbSymbolsCard * nbCardsHeap;

array [1..nbHeaps, 1..nbCardsHeap] of var set of rangeOfHeap: bb;
array [1..nbCards] of var set of rangeOfSymbols: cc;

constraint forall (i in 1..nbHeaps) ( partition_set ( [ bb[i,j] | j in 1..nbCardsHeap ], rangeOfHeap ) );

constraint forall (i in 1..nbHeaps, j in 1..nbCardsHeap) (cc[1+((i-1)*nbCardsHeap)+j] = bb[i,j] union {i});
constraint cc[1] = rangeOfMaster;


constraint forall (c in 1..nbCards) ( card(cc[c]) = nbSymbolsCard );

constraint forall (c1 in 1..nbCards, c2 in 1..nbCards where c1 < c2) ( card (cc[c1] intersect cc[c2]) = 1 );

solve satisfy;

output [show(nbCards), " cards, each with ", show(nbSymbolsCard), " out of ", show(nbSymbols), " symbols\n"] ++
      [ show(c) ++ " = " ++ show(cc[c]) ++ "\n" |
        c in 1..nbCards ];