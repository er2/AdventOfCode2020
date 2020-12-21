
my $group-answers = SetHash.new;
my @answers = gather for ("input.txt".IO.lines) {
  if $_ eq "" {
    take $group-answers;
    $group-answers = SetHash.new;
  } else {
    $group-answers.set($_.comb);
  }
  LAST take $group-answers;
}

say @answers.map(+*).sum;
