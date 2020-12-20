
my $trees-encountered = 0;
for ("input.txt".IO.slurp.lines Z 0..*) -> ($line, $line-number) {
  my $line-length = $line.comb.elems;
  my $x-loc = ($line-number * 3) % $line-length;
  my $hit = $line.comb[$x-loc] eq '#';
  $trees-encountered++ if $hit;
  say $line.substr(0..^$x-loc) ~ ($hit ?? 'X' !! 'O') ~ $line.substr($x-loc);
}

say "Trees encountered: $trees-encountered";
