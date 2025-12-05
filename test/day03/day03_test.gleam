import day03/day03
import day03/parse
import day03/part1
import day03/part2
import gleeunit/should

const part1_example1_answer = Ok(357)

const part2_example1_answer = Ok(3_121_910_778_619)

pub fn part1_example1_test() {
  day03.example1_path
  |> parse.read_input
  |> part1.solve
  |> should.equal(part1_example1_answer)
}

pub fn part2_example1_test() {
  day03.example1_path
  |> parse.read_input
  |> part2.solve
  |> should.equal(part2_example1_answer)
}
