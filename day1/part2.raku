my @nums = "day1input.txt".IO.slurp.lines.map: +*;

my $set = set @nums;

for (@nums X @nums) -> ($n1, $n2) {
  my $target = 2020 - $n1 - $n2;
  if $set{$target} {
    say $target * $n1 * $n2;
    last;
  }
}
