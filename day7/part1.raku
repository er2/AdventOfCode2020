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

# say %rules;
my @flipped = %rules.kv
  .flatmap(-> $k, @v { @v.grep(*.defined).map(* => $k)});

my %flipped = @flipped.categorize: {.key}, :as{.value};
say %flipped;

sub search($color, %rules, $c) {
  for (%rules{$color}) -> @container {
    if @container.defined {
      for (@container) -> $contained {
        say $contained;
        $c.set($contained);
        say $c;
        search($contained, %rules, $c) if !$c{$contained};
      }
    }
  }
}

my SetHash $c .= new;
search('shiny gold', %rules, $c);

say +$c;
