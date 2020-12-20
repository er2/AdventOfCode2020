my @nums = "day1input.txt".IO.slurp.lines.map: +*;

my $set = set @nums;

for (@nums) -> $num {
  my $target = 2020 - $num;
  if $set{$target} {
    say $target * $num;
    last;
  }
}
