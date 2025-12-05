import day02/day02.{type Input}
import gleam/int
import gleam/list
import gleam/result
import gleam/string
import simplifile

pub fn read_input(path) -> Input {
  let assert Ok(contents) = simplifile.read(path)

  string.split(contents, on: ",")
  |> list.map(fn(x) {
    string.split(x, on: "-")
    |> list.filter(fn(s) { s != "" })
    |> list.map(fn(y) { int.parse(y) |> result.unwrap(0) })
  })
  |> list.filter(fn(r) { list.length(r) == 2 })
}

pub fn main() {
  day02.example1_path |> read_input |> echo
}
