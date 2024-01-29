set of int: OBJ = 1..3;
int: men = 1;
int: women = 2;
int: children = 3;

array [OBJ] of int: appetite = [6,4,1];

int: quantity = 200;

int: max = quantity div min(appetite);

array [OBJ] of var 0..max: pop;

constraint sum(pop) = 100;

constraint sum (o in OBJ) (appetite[o] * pop[o]) = quantity;

constraint pop[women] = 5 * pop[men];

solve satisfy;

output ["men: \(pop[men])\nwomen: \(pop[women])\nchildren: \(pop[children])\n"];
