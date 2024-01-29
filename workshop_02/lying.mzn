var bool: huey;
var bool: dewey;
var bool: louie;

constraint dewey = louie;

constraint huey -> dewey;

constraint not (dewey /\ louie);

solve satisfy;