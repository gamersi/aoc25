import day01/day01.{type Input, type Output}
import day01/parse
import gleam/int
import gleam/list
import gleam/result
import gleam/string

pub type State {
  State(position: Int, zero_positions: Int)
}

fn hit_zero(position: Int) -> Int {
  case position {
    0 -> 1
    _ -> 0
  }
}

pub fn solve(input: Input) -> Output {
  let state =
    list.fold(input, State(50, 0), fn(state, instruction) {
      let new_position = apply_instruction(state.position, instruction)
      let new_zero_hits = state.zero_positions + hit_zero(new_position)

      State(position: new_position, zero_positions: new_zero_hits)
    })
  Ok(state.zero_positions)
}

fn apply_instruction(position: Int, instruction: String) -> Int {
  let direction = string.first(instruction)
  let steps = string.drop_start(instruction, 1) |> int.parse |> result.unwrap(0)
  case direction {
    Ok("L") -> {
      position - steps + 100
      |> fn(x) { x % 100 }
    }
    Ok("R") -> {
      position + steps
      |> fn(x) { x % 100 }
    }
    _ -> position
  }
}

pub fn main() -> Output {
  day01.example1_path |> parse.read_input |> solve |> echo
}
