import gleam/bool
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
    |> list.first
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
  // io.debug(boards)
  Ok(#(call_sequence, boards))
}

fn are_all_picked(played, row) {
  row
  |> list.all(fn(n) { list.contains(played, n) })
}

fn check_winner(board: Board, played: List(Int)) -> Bool {
  let has_winning_row =
    board
    |> list.any(fn(row) { are_all_picked(played, row) })

  let has_winning_col =
    board
    |> list.transpose
    |> list.any(fn(row) { are_all_picked(played, row) })

  has_winning_row || has_winning_col
}

fn calculate_score(last_n, played, board) {
  let unmarked_numbers =
    board
    |> list.flatten
    |> list.filter(fn(n) {
      list.contains(played, n)
      |> bool.negate
    })

  let sum =
    unmarked_numbers
    |> int.sum

  sum * last_n
}

fn play(played, remainder, boards) {
  case remainder {
    [] -> Error("No winner")
    [n, ..rest] -> {
      let next_played = [n, ..played]
      //
      let maybe_winner =
        boards
        |> list.find(fn(board) { check_winner(board, next_played) })
      //
      case maybe_winner {
        Ok(winner) -> {
          let score = calculate_score(n, next_played, winner)
          Ok(score)
        }
        Error(_) -> play(next_played, rest, boards)
      }
    }
  }
}

pub fn part1(file: String) {
  try #(sequence, boards) = read_input(file)

  play([], sequence, boards)
}

fn find_worst(played, remainder, boards) {
  case remainder {
    [] -> Error("Not found")
    [n, ..rest] -> {
      // io.debug("play")
      // io.debug(n)
      let next_played = [n, ..played]
      //
      let #(winners, not_winners) =
        boards
        |> list.partition(fn(b) { check_winner(b, next_played) })
      //
      case not_winners {
        [] ->
          case winners {
            [] -> Error("Not found")
            [b] -> {
              let score = calculate_score(n, next_played, b)
              Ok(score)
            }
          }
        _ ->
          // Keep going
          find_worst(next_played, rest, not_winners)
      }
    }
  }
}

pub fn part2(file: String) {
  try #(sequence, boards) = read_input(file)

  find_worst([], sequence, boards)
}
