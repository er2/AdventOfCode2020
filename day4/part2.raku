grammar Passports {
  token TOP { <passport>+ %% \v }
  token passport { <keyvalue>+ %% \s }
  token keyvalue { <key> ":" <value> }
  token key { <[a..z]> ** 3 }
  token value { \S+ }
}

my $keys = Set.new: <byr iyr eyr hgt hcl ecl pid cid>;

class Passportss {
  method TOP     ($/) { make $<passport>.map: *.made; }
  method passport($/) { make Hash.new($<keyvalue>.map(*.made)); }
  method keyvalue($/) { make ~$<key> => (~$<value>); }
}

my $eye-colors = Set.new: <amb blu brn gry grn hzl oth>;

sub validate(% (:$byr, :$iyr, :$eyr, :$hgt, :$hcl, :$ecl, :$pid, :$cid?) --> Bool) {
  [&&] (
    1920 <= +$byr <= 2002,
    2010 <= +$iyr <= 2020,
    2020 <= +$eyr <= 2030,
    valid-height($hgt),
    so $hcl ~~ /'#' <xdigit> ** 6/,
    $eye-colors{$ecl},
    so $pid ~~ /\d ** 9/
  )
}

sub valid-height($hgt) {
  given $hgt {
    when /$<cms> = (\d+) "cm"/ { 150 <= +$<cms> <= 193 }
    when /$<inches> = (\d+) "in"/ { 59 <= +$<inches> <= 76 }
    default { False }
  }
}

my @passports = Passports.parsefile("input.txt", actions => Passportss).made;

my $valid-count = 0;

for (@passports) -> $passport {
  my $pp-keys = SetHash.new: $passport.keys;
  $pp-keys.set('cid');
  if $keys ~~ $pp-keys && validate($passport) {
    say $passport<hgt>;
    $valid-count++;
  }
}

say "Valid $valid-count";
