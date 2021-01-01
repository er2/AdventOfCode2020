grammar Code {
  token TOP { <line>+ %% \v }
  token line { <instruction> \s <argument> }
  token instruction { "acc" | "jmp" | "nop" }
  token argument {  [ "+" | "-" ] \d+ }
}

class Interpreter {
  method TOP($/) { make $<line>.map: *.made; }
  method line($/) { make ~$<instruction> => +$<argument> }
}

my @lines = Code.parsefile("input.txt", actions => Interpreter).made;

my $accumulator = 0;
my $executed-lines = SetHash.new;

sub run(Int $line-number, @lines) {

  die "$accumulator" if $executed-lines{$line-number};

  $executed-lines.set($line-number);

  my ($instruction, $argument) = @lines[$line-number].kv;

  given $instruction {
    when "acc" {
      $accumulator += $argument;
      run($line-number + 1, @lines);
    }
    when "jmp" {
      run($line-number + $argument, @lines);
    }
    when "nop" {
      run($line-number + 1, @lines);
    }
  }
}

for (@lines Z 0..*) -> ($line, $line-number) {
  $accumulator = 0;
  my ($instruction, $argument) = @lines[$line-number].kv;
  last if $instruction === "acc";
  my @fixed-lines = @lines.clone;
  my $fixed-instruction = $instruction === "nop" ?? "jmp" !! "nop";
  @fixed-lines[$line-number] = $fixed-instruction => $argument;
  do {
    run(0, @fixed-lines);
    CATCH { }
    LEAVE {
      say "Success: $accumulator"
    }
  }
}
