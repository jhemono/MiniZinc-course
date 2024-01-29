include "alldifferent.mzn";

int: order = 7;
set of int: Seven = 1..order;
set of int: Eight = 0..order;
set of int: Symbols = 0..order*(order+1);
Symbols: infinitySymbol = 0;

% Diagonals
array [Seven] of int: step = 0..6;

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

solve satisfy;

output ["constraint cards[" ++
        show(card) ++ ", " ++ show(symbol) ++
        "] = " ++
        show_int(2,infini[card,symbol]) ++
        ";\n" |
        card in Eight, symbol in Eight] ++
       ["constraint cards[" ++
        show((row-1)*7+column+7) ++ ", " ++ show(symbol) ++
        "] = " ++
        show_int(2,plane[row,column,symbol]) ++
        ";\n" |
        row in Seven, column in Seven, symbol in Eight];