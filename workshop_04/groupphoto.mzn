int: n;

set of int: People = 1..n;
set of int: Place = 1..n;
array [People,People] of bool: friend;

int: split = n div 2;

array [Place] of var People: occupant;

include "globals.mzn";

constraint alldifferent(occupant);

var int: adjacencies = sum (pl in 1..n-1 where pl != split) (friend[occupant[pl],occupant[pl+1]]) +
                       sum (pl in 1..split) (friend[occupant[pl],occupant[pl+split]]);

solve maximize adjacencies;

int: digits = 3;

output [ show_int(digits, occupant[pl]) | pl in People where pl <= split ] ++ ["\n"] ++
       [ show_int(digits, occupant[pl]) | pl in People where pl > split ] ++
       [ "\nAdjacencies : \(adjacencies)\n" ];