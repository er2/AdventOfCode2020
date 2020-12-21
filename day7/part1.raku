grammar Rules {
  token TOP { <rule>+ %% \v+ }
  token rule { <color> ' bags contain ' <contents> '.' }
  token color { \w+ \s \w+ }
  token contents { <empty> | <non-empty> }
  token empty { 'no other bags' }
  token non-empty { <full-bag>+ %% ', ' }
  token full-bag { <number> \s <color> \s <bag> }
  token number { \d+ }
  token bag { 'bag' | 'bags' }
}

class BuildRuleTree {
  method TOP($/) { make $<rule>.map(*.made).Hash; }
}

say Rules.parsefile("input.txt");
