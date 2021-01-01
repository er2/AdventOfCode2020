my @preamble;

for ("input.txt".IO.lines Z 0..*) -> ($line, $line-number) {
  if $line-number <= 25 {
    @preamble.push(+$line);
  } else {

  }
}
