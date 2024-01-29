% Dobble with set

include "globals.mzn";

int: nbCards = 7;
int: nbSymbols = 7;
int: nbSymbolsOnCards = 3;

set of int: Symbols = 1..nbSymbols;

array[1..nbCards] of var set of Symbols : distribution;

constraint forall (c in 1..nbCards) ( card(distribution[c]) = nbSymbolsOnCards );

constraint at_most1(distribution);

solve satisfy;

output [show(nbCards), " cards, each with ", show(nbSymbolsOnCards), " out of ", show(nbSymbols), " symbols\n"] ++
      [ show(c) ++ " = " ++ show(distribution[c]) ++ "\n" |
        c in 1..nbCards ];