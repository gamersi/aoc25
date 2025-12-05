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
  let len = string.length(s)

  len > 1 && has_repeated_chunk(s, len, 1)
}

fn has_repeated_chunk(s: String, len: Int, chunk_len: Int) -> Bool {
  case chunk_len > len / 2 {
    True -> False
    False -> {
      case len % chunk_len == 0 {
        True ->
          case matches_chunk(s, len, chunk_len) {
            True -> True
            False -> has_repeated_chunk(s, len, chunk_len + 1)
          }
        False -> has_repeated_chunk(s, len, chunk_len + 1)
      }
    }
  }
}

fn matches_chunk(s: String, len: Int, chunk_len: Int) -> Bool {
  let chunk = string.slice(s, 0, chunk_len)
  compare_chunk(s, chunk, chunk_len, chunk_len, len)
}

fn compare_chunk(
  s: String,
  chunk: String,
  chunk_len: Int,
  index: Int,
  len: Int,
) -> Bool {
  case index >= len {
    True -> True
    False -> {
      let next = string.slice(s, index, chunk_len)
      case next == chunk {
        True -> compare_chunk(s, chunk, chunk_len, index + chunk_len, len)
        False -> False
      }
    }
  }
}

pub fn main() -> Output {
  day02.example1_path |> parse.read_input |> solve |> echo
}
