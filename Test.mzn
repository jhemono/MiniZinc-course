include "alldifferent.mzn";

int: order = 7;
set of int: indexes = 0..order;
set of int: range = -order..order;
int: d = -3;

var set of range: result;

constraint forall (i in indexes, j in indexes)
           ( (((d*i) + j) mod order) in result );

solve minimize card(result);

output [show(result)];