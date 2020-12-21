use Grammar::Debugger;

grammar GroupAnswers {
  rule TOP               { <group-answer>+ %% \v+ }
  rule group-answer      { <individual-answer>+ %% '\n' }
  rule individual-answer { <[a..z]>+ }
}

class GroupEvaluator {
  method TOP($/)               {
    # say "Group: \{$<group-answer>\}";
    make $<group-answer>.map: *.made; }

  method group-answer($/)      {
    # say "Indiv: [{$<individual-answer>}]";
    make [+] $<individual-answer>.map: *.made; }

  method individual-answer($/) {
    my $res = set $/.comb;
    # say "Set: $res";
    make $res; }
}

sub MAIN {
  say GroupAnswers.parsefile("input.txt", actions => GroupEvaluator).made;
}
