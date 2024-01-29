% Dobble

int: nbCards = 31;
int: nbSymbols = 31;
int: nbSymbolsOnCards = 5;

array[1..nbCards, 1..nbSymbols] of var bool: distribution;

constraint forall (c in 1..nbCards)
           ( sum (s in 1..nbSymbols) ( distribution[c,s] ) = nbSymbolsOnCards );

constraint forall (c1 in 1..nbCards, c2 in 1..nbCards where c1 < c2 )
           ( sum (s in 1..nbSymbols) ( distribution[c1,s] /\ distribution[c2,s] ) = 1 );

solve maximize nbSymbolsOnCards;

output [show(nbCards), " cards, each with ", show(nbSymbolsOnCards), " out of ", show(nbSymbols), "symbols\n"] ++
      [ if s = 1 then show(c) ++ " = " else "" endif ++ show(distribution[c,s]) ++ if s = nbSymbols then "\n" else " " endif |
        c in 1..nbCards, s in 1..nbSymbols ];