import day01/day01
import day01/parse
import day01/part1
import day01/part2
import gleeunit/should

const part1_example1_answer = Ok(3)

const part2_example1_answer = Ok(6)

pub fn part1_example1_test() {
  day01.example1_path
  |> parse.read_input
  |> part1.solve
  |> should.equal(part1_example1_answer)
}

pub fn part2_example1_test() {
  day01.example1_path
  |> parse.read_input
  |> part2.solve
  |> should.equal(part2_example1_answer)
}
