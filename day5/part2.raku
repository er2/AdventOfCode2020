my regex frontback { [ 'F' | 'B' ] ** 7 }
my regex leftright { [ 'L' | 'R'] ** 3 }
my regex seat { ^ <frontback> <leftright> $ }

sub calc-row(Str() $frontback) {
  parse-binary($frontback, * eq 'B');
}

sub calc-column(Str() $leftright) {
  parse-binary($leftright, * eq 'R');
}

sub parse-binary(Str $string, WhateverCode $test) {
  +('0b' ~ $string.comb.map({+$test($^a)}).join);
}

sub calc-seat-id(Int $row, Int $column) {
  $row * 8 + $column
}

sub find-gap(@seats) {
  my $gap;
  for (@seats) -> $current, $next {
    if $next != $current + 1 {
      $gap = $current + 1;
      last;
    }
  }
  $gap;
}

my @seat-ids = gather {
  for ("input.txt".IO.lines) -> $line {
    given $line {
      when /<seat>/ {
        my ($row-str, $col-str) = $<seat>.hash<frontback leftright>;
        take calc-seat-id(calc-row($row-str), calc-column($col-str));
      }
    }
  }
}

@seat-ids.=sort;

say "My seat is {find-gap(@seat-ids)}";
