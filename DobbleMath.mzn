include "alldifferent.mzn";

int: order = 7;
set of int: Seven = 1..order;
set of int: Eight = 0..order;
set of int: Symbols = 0..order*(order+1);
Symbols: infinitySymbol = 0;

% Diagonals
array [Seven] of int: step = 0..order-1;

% Variables
array [Eight, Eight] of var Symbols : infini;
array [Seven, Seven, Eight] of var Symbols: plane;

% Infinity line
constraint forall (i in Eight)
           ( infini[i,0] = infinitySymbol /\
             forall (j in Seven)
             ( infini[i,j] != infinitySymbol));

constraint alldifferent (i in Eight, j in Seven)
           ( infini[i,j] );

% Plane
constraint forall (i in Seven, j in Seven)
           ( plane[i,j,0] = infini[0,i] );

constraint forall (d in Seven, i in Seven, j in Seven)
           ( plane[i,j,d] = infini[d, (((step[d]*(i-1)) + (j-1)) mod order)+1] );

% Validity Check - Should be done separately

array [Symbols] of var set of Symbols: cards;

constraint forall (i in Eight, j in Eight)
           ( infini[i,j] in cards[i] );

constraint forall (i in Seven, j in Seven, k in Eight)
           ( plane[i,j,k] in cards[i*order+j] );

constraint forall (c in Symbols)
           ( card(cards[c]) = order+1 );

constraint forall (c1 in Symbols, c2 in Symbols where c1 < c2)
           ( card(cards[c1] intersect cards[c2]) = 1 );

constraint forall (s1 in Symbols, s2 in Symbols where s1 < s2)
           ( exists (c in Symbols)
             ( s1 in cards[c] /\ s2 in cards[c] ) );

solve satisfy;

output [show_int(2,infini[card,symbol]) ++
        if symbol = order then "\n" else " " endif |
        card in Eight, symbol in Eight] ++
       [show_int(2,plane[row, column, symbol]) ++
        if symbol = order then "\n" else " " endif |
        row in Seven, column in Seven, symbol in Eight];