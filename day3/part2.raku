
sub count-tree-hits(Int :$right, Int :$down --> Int) {
  my $trees-encountered = 0;
  my @input = "input.txt".IO.slurp.lines.grep: { $++ %% $down };
  for (@input Z 0..*) -> ($line, $line-number) {
    my $line-length = $line.comb.elems;
    my $x-loc = ($line-number * $right) % $line-length;
    my $hit = $line.comb[$x-loc] eq '#';
    $trees-encountered++ if $hit;
    say $line.substr(0..^$x-loc) ~ ($hit ?? 'X' !! 'O') ~ $line.substr($x-loc);
  }

  say "Trees encountered: $trees-encountered";
  $trees-encountered;
}

my $product = [*] gather {
  take count-tree-hits(:1right, :1down);
  take count-tree-hits(:3right, :1down);
  take count-tree-hits(:5right, :1down);
  take count-tree-hits(:7right, :1down);
  take count-tree-hits(:1right, :2down);
}

say "Product: $product";
