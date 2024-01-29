var bool: A;
var bool: B;
var bool: C;

array [1..3] of var bool: knaves = [A,B,C];
array [1..3] of var bool: knights = [not A, not B, not C];

constraint A xor (sum (knights) = 1);
constraint B xor (sum (knights) = 2);
constraint C xor (sum (knights) = 3);

solve satisfy;