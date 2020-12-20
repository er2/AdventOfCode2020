# use Grammar::Debugger;

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

my @passports = Passports.parsefile("input.txt", actions => Passportss).made;

my $valid-count = 0;

for (@passports) -> $passport {
  my $pp-keys = SetHash.new: $passport.keys;
  $pp-keys.set('cid');
  $valid-count++ if $keys ~~ $pp-keys;
}

say "Valid $valid-count";
