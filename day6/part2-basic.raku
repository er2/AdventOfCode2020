my $group-answers = Nil;
my @answers = gather for ("input.txt".IO.lines) {
  if $_ eq "" {
    take $group-answers;
    $group-answers = Nil;
  } elsif !$group-answers.defined {
    $group-answers = SetHash.new: .comb;
  } else {
    $group-answers = $group-answers ∩ .comb;
  }
  LAST take $group-answers;
}

say @answers.map(*.elems).sum;
