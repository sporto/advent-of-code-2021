import gleam/int
import gleam/list
import gleam/result
import gleam/string
import utils

type Op {
  Down
  Up
  Forward
}

fn parse_operation(input: String) -> Result(Op, String) {
  case input {
    "down" -> Ok(Down)
    "up" -> Ok(Up)
    "forward" -> Ok(Forward)
    _ -> Error("Invalid operation")
  }
}

fn parse_line(line: String) -> Result(#(Op, Int), String) {
  try #(a, b) =
    string.split_once(line, on: " ")
    |> result.replace_error("Cannot split")

  try op = parse_operation(a)

  try dist =
    int.parse(b)
    |> result.replace_error("Invalid dist")

  Ok(#(op, dist))
}

fn read_input(file: String) {
  utils.get_input_lines(file, parse_line)
}

type Position {
  Position(hor: Int, depth: Int)
}

fn move(pos: Position, operation: #(Op, Int)) -> Position {
  let #(op, dist) = operation
  case op {
    Forward -> Position(..pos, hor: pos.hor + dist)
    Down -> Position(..pos, depth: pos.depth + dist)
    Up -> Position(..pos, depth: pos.depth - dist)
  }
}

pub fn part1(input: String) {
  try input = read_input(input)

  let initial = Position(0, 0)

  let position =
    input
    |> list.fold(from: initial, with: move)

  Ok(position.hor * position.depth)
}

type PositionV2 {
  PositionV2(hor: Int, depth: Int, aim: Int)
}

fn move_v2(pos: PositionV2, operation: #(Op, Int)) -> PositionV2 {
  let #(op, dist) = operation
  case op {
    Forward ->
      PositionV2(..pos, hor: pos.hor + dist, depth: pos.depth + pos.aim * dist)
    Down -> PositionV2(..pos, aim: pos.aim + dist)
    Up -> PositionV2(..pos, aim: pos.aim - dist)
  }
}

pub fn part2(input: String) {
  try input = read_input(input)

  let initial = PositionV2(0, 0, 0)

  let position =
    input
    |> list.fold(from: initial, with: move_v2)

  Ok(position.hor * position.depth)
}
