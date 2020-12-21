my $group-answers = Nil;
my @answers = gather for ("input.txt".IO.lines) {
  if $_ eq "" {
    take $group-answers;
    say "FLUSH $group-answers             SIZE: {$group-answers.elems}";
    $group-answers = Nil;
  } elsif !$group-answers.defined {
    $group-answers = SetHash.new: .comb;
    say "INITIAL SET $group-answers";
  } else {
    $group-answers = $group-answers ∩ .comb;
    say "INTERSECT $group-answers";
  }
  LAST take $group-answers;
}

say @answers.map(*.elems).sum;
