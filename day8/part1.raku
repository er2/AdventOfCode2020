# use Grammar::Debugger;

grammar Code {
  token TOP { <line>+ %% \v }
  token line { <instruction> \s <argument> }
  token instruction { "acc" | "jmp" | "nop" }
  token argument { <sign> <number> }
  token sign { "+" | "-" }
  token number { \d+ }
}

class Interpreter {
  method TOP($/) { make $<line>.map: *.made; }
  method line($/) { make ~$<instruction> => +$<argument> }
}

my @lines = Code.parsefile("input.txt", actions => Interpreter).made;

my $accumulator = 0;
my $executed-lines = SetHash.new;

sub run(Int $line-number, @lines) {
  if $executed-lines{$line-number} {
    die "$accumulator";
  } else {
    $executed-lines.set($line-number);
  }
  my ($instruction, $argument) = @lines[$line-number].kv;
  say "$instruction --- $argument";
  given $instruction {
    when "acc" {
      $accumulator += $argument;
      run($line-number+1, @lines);
    }
    when "jmp" {
      run($line-number + $argument, @lines);
    }
    when "nop" {
      run($line-number+1, @lines);
    }
  }
}

run(0, @lines);

say $accumulator;
