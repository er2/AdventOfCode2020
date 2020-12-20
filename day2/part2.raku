# note: pipe output to `column -ts '|'` for greater readability

# use Grammar::Debugger;

use Colorizable;

grammar PWEntry {
  token TOP    { <minmax> \s <letter> ":" \s <pw> }
  token minmax { <low> "-" <high> }
  token low    { \d+ }
  token high   { \d+ }
  token letter { <[a..z]> }
  token pw     { <[a..z]>+ }
}

sub validate(% (:$minmax, :$letter, :$pw)) {

  my @indices = $minmax<low high>.map: +* - 1;

  $letter ~~ one($pw.comb[@indices])
}

my $valid-count = 0;
for ("input.txt".IO.slurp.lines) -> $line {
  my $parsed = PWEntry.parse($line);
  if $parsed {
    my $pw = $parsed<pw>;
    my $valid = so validate($parsed.hash);
    my $out = "$pw|{$valid ?? "✅" !! "⚠️"}|$line" but Colorizable;
    if $valid {
      say $out.green;
      $valid-count++;
    } else {
      say $out.red;
    }
  } else {
    say "error";
    say $parsed;
    last;
  }
}

say "Total valid passwords: $valid-count";
