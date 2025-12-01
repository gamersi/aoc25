import day01/day01.{type Input, type Output}
import day01/parse
import gleam/int
import gleam/list
import gleam/result
import gleam/string

pub type State {
  State(position: Int, zero_positions: Int)
}

fn distance_to_zero(position: Int, direction: Int) -> Int {
  let distance = case direction {
    1 -> 100 - position
    -1 -> position
    _ -> 0
  }

  case distance {
    0 -> 100
    distance -> distance
  }
}

fn zero_hits(start: Int, direction: Int, steps: Int) -> Int {
  case direction {
    0 -> 0
    _ -> {
      let distance = distance_to_zero(start, direction)
      case steps < distance {
        True -> 0
        False -> 1 + { steps - distance } / 100
      }
    }
  }
}

fn positive_mod(n: Int, m: Int) -> Int {
  int.modulo(n, by: m) |> result.unwrap(0)
}

pub fn solve(input: Input) -> Output {
  let state =
    list.fold(input, State(50, 0), fn(state, instruction) {
      let direction = string.first(instruction)
      let steps =
        string.drop_start(instruction, 1) |> int.parse |> result.unwrap(0)
      let direction_sign = case direction {
        Ok("L") -> -1
        Ok("R") -> 1
        _ -> 0
      }
      let delta = direction_sign * steps

      let start = state.position
      let raw_end = start + delta

      let hits = zero_hits(start, direction_sign, steps)
      let new_position = positive_mod(raw_end, 100)
      let new_zero_hits = state.zero_positions + hits

      State(position: new_position, zero_positions: new_zero_hits)
    })
  Ok(state.zero_positions)
}

pub fn main() -> Output {
  day01.example1_path |> parse.read_input |> solve |> echo
}
