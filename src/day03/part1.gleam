import day03/day03.{type Input, type Output}
import day03/parse
import gleam/int
import gleam/list
import gleam/result
import gleam/string

const target_len = 2

fn find_biggest_joltage(line: String) -> Int {
  let digits =
    string.to_graphemes(line)
    |> list.map(fn(d) { int.parse(d) |> result.unwrap(0) })

  digits
  |> choose_digits(int.min(target_len, list.length(digits)))
  |> digits_to_int
}

fn choose_digits(digits: List(Int), len_to_keep: Int) -> List(Int) {
  let to_remove = list.length(digits) - len_to_keep
  select_digits(digits, to_remove, []) |> list.reverse |> list.take(len_to_keep)
}

fn select_digits(
  digits: List(Int),
  to_remove: Int,
  stack: List(Int),
) -> List(Int) {
  case digits {
    [] -> stack
    [digit, ..rest] -> {
      let #(stack2, to_remove2) = drop_smaller(stack, digit, to_remove)
      select_digits(rest, to_remove2, [digit, ..stack2])
    }
  }
}

fn drop_smaller(
  stack: List(Int),
  digit: Int,
  to_remove: Int,
) -> #(List(Int), Int) {
  case stack {
    [] -> #(stack, to_remove)
    [top, ..rest] ->
      case to_remove > 0 && top < digit {
        True -> drop_smaller(rest, digit, to_remove - 1)
        False -> #(stack, to_remove)
      }
  }
}

fn digits_to_int(digits: List(Int)) -> Int {
  list.fold(digits, 0, fn(acc, digit) { acc * 10 + digit })
}

pub fn solve(input: Input) -> Output {
  let sum =
    input
    |> list.map(fn(line) { find_biggest_joltage(line) })
    |> list.fold(0, int.add)

  Ok(sum)
}

pub fn main() -> Output {
  day03.example1_path |> parse.read_input |> solve |> echo
}
