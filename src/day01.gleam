import gleam/list
import gleam/io
import gleam/result
import utils
import gleam/int

fn parse_line(line: String) -> Result(Int, String) {
  int.parse(line)
  |> result.replace_error("Couldn't parse line")
}

fn read_input(file: String) {
  utils.get_input_lines(file, parse_line)
}

type Move {
  Increase
  Decrease
}

fn count_move(move: Move) -> Int {
  case move {
    Increase -> 1
    Decrease -> 0
  }
}

fn count_increases(input) {
  let moves =
    input
    |> list.window_by_2
    |> list.map(fn(t) {
      let #(a, b) = t
      case a < b {
        True -> Increase
        False -> Decrease
      }
    })

  let increases =
    moves
    |> list.map(count_move)
    |> int.sum
}

pub fn part1() -> Result(Int, String) {
  try input = read_input("./data/01/input.txt")

  let increases = count_increases(input)

  Ok(increases)
}

pub fn part2() -> Result(Int, String) {
  try input = read_input("./data/01/input.txt")

  let sums =
    input
    |> list.window(by: 3)
    |> list.map(int.sum)

  let increases = count_increases(sums)

  Ok(increases)
}
