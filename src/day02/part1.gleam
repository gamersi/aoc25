import day02/day02.{type Input, type Output}
import day02/parse
import gleam/int
import gleam/list
import gleam/result
import gleam/string

pub type Range {
  Range(start: Int, stop: Int)
}

pub fn solve(input: Input) -> Output {
  let sum =
    input
    |> list.map(fn(r) {
      sum_invalid_ids(
        list.first(r) |> result.unwrap(0),
        list.last(r) |> result.unwrap(0),
      )
    })
    |> list.fold(0, int.add)

  Ok(sum)
}

fn sum_invalid_ids(start: Int, stop: Int) -> Int {
  iterate(start, stop, 0)
}

fn iterate(n: Int, stop: Int, acc: Int) -> Int {
  case n > stop {
    True -> acc
    False -> {
      let acc2 = case is_invalid(n) {
        True -> acc + n
        False -> acc
      }
      iterate(n + 1, stop, acc2)
    }
  }
}

fn is_invalid(n: Int) -> Bool {
  let s = int.to_string(n)

  case string.length(s) % 2 == 0 {
    False -> False
    True ->
      case string.starts_with(s, "0") {
        True -> False
        False -> {
          let half = string.length(s) / 2
          let a = string.slice(s, 0, half)
          let b = string.slice(s, half, string.length(s))
          a == b
        }
      }
  }
}

pub fn main() -> Output {
  day02.example1_path |> parse.read_input |> solve |> echo
}
