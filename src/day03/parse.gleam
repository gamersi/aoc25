import day03/day03.{type Input}
import gleam/string
import simplifile

pub fn read_input(input_path) -> Input {
  let assert Ok(contents) = simplifile.read(input_path)
  string.split(contents, on: "\n")
}

pub fn main() {
  day03.example1_path |> read_input |> echo
}
