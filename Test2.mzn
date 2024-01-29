int: a = -2;
int: b = 7;

var int: d;
var -b..b: m;

constraint d = a div b;
constraint m = a mod b;

solve satisfy;

output [show(d), " ", show(m)];