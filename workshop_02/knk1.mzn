var bool: A;
var bool: B;
var bool: C;

array [1..3] of var bool: knaves = [A,B,C];
array [1..3] of var bool: knights = [not A, not B, not C];

constraint A xor (sum (knaves) = 1);
constraint B xor (sum (knaves) = 2);
constraint C xor (sum (knaves) = 3);

solve satisfy;