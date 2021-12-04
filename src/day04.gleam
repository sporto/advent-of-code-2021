import gleam/int
import gleam/list
import gleam/result
import gleam/string
import gleam/io
import utils

type Board =
  List(List(Int))

fn get_call_sequence(file: String) -> Result(List(Int), String) {
  try first_line =
    file
    |> utils.split_lines
    |> list.head
    |> result.replace_error("Couldn't get first line")

  first_line
  |> string.split(",")
  |> list.map(int.parse)
  |> result.all
  |> result.replace_error("Couldn't parse")
}

fn get_boards_input(acc, lines) {
  case lines {
    [] -> acc
    _ -> {
      let board = list.take(lines, 5)
      let remainder = list.drop(lines, 6)
      get_boards_input([board, ..acc], remainder)
    }
  }
}

fn parse_board_line(line: String) -> Result(List(Int), String) {
  line
  |> string.split(" ")
  |> list.filter(fn(c) { c != "" })
  |> list.map(int.parse)
  |> result.all
  |> result.replace_error("Couldn't parse line")
}

fn parse_board(lines: List(String)) {
  lines
  |> list.map(parse_board_line)
  |> result.all
}

fn get_boards(file: String) -> Result(List(Board), String) {
  let lines =
    file
    |> utils.split_lines
    |> list.drop(2)

  let boards_input = get_boards_input([], lines)

  boards_input
  |> list.map(parse_board)
  |> result.all
}

fn read_input(file: String) {
  try file =
    utils.read_file(file)
    |> result.replace_error("Could not read file")

  try call_sequence = get_call_sequence(file)

  try boards = get_boards(file)

  // io.debug(call_sequence)
  io.debug(boards)

  Ok(call_sequence)
}

pub fn part1(file: String) {
  try input = read_input(file)

  Ok(0)
}
