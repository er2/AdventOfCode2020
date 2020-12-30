grammar Rules {
  token TOP { <rule>+ %% \v }
  token rule { <color> ' bags contain ' <contents> '.' }
  token color { \w+ \s \w+ }
  token contents { <empty> | <non-empty> }
  token empty { 'no other bags' }
  token non-empty { <full-bag>+ %% ', ' }
  token full-bag { <number> \s <color> \s <bag> }
  token number { \d+ }
  token bag { 'bag' | 'bags' }
}

class BuildRuleMap {
  method TOP($/)       { make $<rule>.flatmap(*.made).categorize: {.key}, :as{.value}; }
  method rule($/)      { make $<contents>.made.map: ~$<color> => * }
  method contents($/)  { make ($<empty> // $<non-empty>).made; }
  method empty($/)     { () }
  method non-empty($/) { make $<full-bag>.map: *.made; }
  method full-bag($/)  { make ~$<color> }
}

my %rules = Rules.parsefile("input.txt", actions => BuildRuleMap).made;

say %rules;
my @flipped = %rules.kv
  .flatmap(-> $k, @v { @v.grep(*.defined).map(* => $k)});

my %flipped = @flipped.categorize: {.key}, :as{.value};
say %flipped;

sub search($color, %rules, &accept) {
  for (%rules{$color}) -> $container {
    &accept($container);
    search($color, %rules, &accept);
  }
}

my SetHash $c .= new;
sub consume { $c.set($^a) }
search('shiny gold', %rules, &consume);

say +$c;
