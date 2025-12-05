import day02/day02
import day02/parse
import day02/part1
import day02/part2
import gleeunit/should

const part1_example1_answer = Ok(1_227_775_554)

const part2_example1_answer = Ok(4_174_379_265)

pub fn part1_example1_test() {
  day02.example1_path
  |> parse.read_input
  |> part1.solve
  |> should.equal(part1_example1_answer)
}

pub fn part2_example1_test() {
  day02.example1_path
  |> parse.read_input
  |> part2.solve
  |> should.equal(part2_example1_answer)
}
