#!/bin/bash

DAY=$1
[[ -z $2 ]] && YEAR=2025 || YEAR=$2

if [ -z "$DAY" ]; then
  echo "Please provide the day"
  exit 0
fi

if (("$DAY" > 25 || "$DAY" < 1)); then
  echo "There's no Day $DAY"
  exit 0
fi

if ((YEAR < 2015 || YEAR > $(date +"%Y"))); then
  echo "The year passed must be valid"
  exit 0
fi

COOKIE=.cookie
if [ ! -f "$COOKIE" ]; then
  echo "Store your AoC session cookie in '.cookie'"
  exit 0
fi

PADDED=$(printf "%02d" "$DAY")
DAYSTR="day${PADDED}"
SOLUTION_PATH="src/${DAYSTR}"
TEST_PATH="test/${DAYSTR}"

if [ -f "SOLUTION_PATH" ]; then
  echo "Day $DAY already exists"
  exit 0
fi

EXAMPLE_PATH="test/day${PADDED}/examples"
RESOURCE_PATH="inputs/day${PADDED}"
mkdir -p $SOLUTION_PATH
mkdir -p $EXAMPLE_PATH
mkdir -p $RESOURCE_PATH

cat >"${SOLUTION_PATH}/${DAYSTR}.gleam" <<EOL
pub type Input =
  Nil

pub type Output =
  Result(Int, String)

pub const input_path = "inputs/${DAYSTR}/input.txt"

pub const example1_path = "test/${DAYSTR}/examples/example1.txt"

pub const example2_path = "test/${DAYSTR}/examples/example2.txt"
EOL

cat >"${SOLUTION_PATH}/parse.gleam" <<EOL
import ${DAYSTR}/${DAYSTR}.{type Input}
import gleam/string
import simplifile

pub fn read_input(input_path) -> Input {
  let assert Ok(contents) = simplifile.read(input_path)
  string.split(contents, on: "\n")
}

pub fn main() {
  ${DAYSTR}.example1_path |> read_input |> echo
}
EOL

cat >"${SOLUTION_PATH}/part1.gleam" <<EOL
import ${DAYSTR}/${DAYSTR}.{type Input, type Output}
import ${DAYSTR}/parse


pub fn solve(input: Input) -> Output {
  todo
}

pub fn main() -> Output {
  ${DAYSTR}.example1_path |> parse.read_input |> solve |> echo
}
EOL

cat >"${SOLUTION_PATH}/part2.gleam" <<EOL
import ${DAYSTR}/${DAYSTR}.{type Input, type Output}
import ${DAYSTR}/parse


pub fn solve(input: Input) -> Output {
  todo
}

pub fn main() -> Output {
  ${DAYSTR}.example1_path |> parse.read_input |> solve |> echo
}
EOL

cat >"${SOLUTION_PATH}/run.gleam" <<EOL
import ${DAYSTR}/${DAYSTR}
import ${DAYSTR}/parse
import ${DAYSTR}/part1
import ${DAYSTR}/part2
import common/runner

pub const part1_expected = 0

pub const part2_expected = 0

pub fn main() {
  let input = parse.read_input(${DAYSTR}.input_path)
  runner.run_day(${DAY}, input, [
    runner.int_part("Part 1", part1_expected, part1.solve),
    runner.int_part("Part 2", part2_expected, part2.solve),
  ])
}
EOL

cat >"${TEST_PATH}/${DAYSTR}_test.gleam" <<EOL
import ${DAYSTR}/${DAYSTR}
import ${DAYSTR}/parse
import ${DAYSTR}/part1
import ${DAYSTR}/part2
import gleeunit/should

const part1_example1_answer = Ok(0)

const part2_example1_answer = Ok(0)

pub fn part1_example1_test() {
  ${DAYSTR}.example1_path
  |> parse.read_input
  |> part1.solve
  |> should.equal(part1_example1_answer)
}

// pub fn part2_example1_test() {
//   ${DAYSTR}.example1_path
//   |> parse.read_input
//   |> part2.solve
//   |> should.equal(part2_example1_answer)
// }
EOL

INPUT_PATH="${RESOURCE_PATH}/input.txt"
aoc -s $COOKIE -y "$YEAR" -d "$DAY" -I -i "$INPUT_PATH" -o download

touch "${EXAMPLE_PATH}/example1.txt"
touch "${EXAMPLE_PATH}/example2.txt"

RUNNER="src/aoc25.gleam"

echo "// Auto-generated runner for all solved days" > "$RUNNER"
echo "" >> "$RUNNER"

for daydir in src/day??; do
  if [ -f "$daydir/run.gleam" ]; then
    daynum=$(basename "$daydir")
    echo "import ${daynum}/run as ${daynum}_run" >> "$RUNNER"
  fi
done

echo "" >> "$RUNNER"
echo "pub fn main() {" >> "$RUNNER"

for daydir in src/day??; do
  if [ -f "$daydir/run.gleam" ]; then
    daynum=$(basename "$daydir")
    echo "  ${daynum}_run.main()" >> "$RUNNER"
  fi
done

echo "}" >> "$RUNNER"