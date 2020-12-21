# use Grammar::Debugger;

grammar GroupAnswers {
  token TOP               { <group-answer>+ %% \v+ }
  token group-answer      { <individual-answer>+ %% \s }
  token individual-answer { <[a..z]>+ }
}

class GroupEvaluator {
  method TOP($/)               { make $<group-answer>.map: *.made; }
  method group-answer($/)      { make [∩] $<individual-answer>.map: *.made; }
  method individual-answer($/) { make set $/.comb; }
}

my @answers = GroupAnswers.parsefile("input.txt", actions => GroupEvaluator).made;
say @answers.map(+*).sum;
