import gleam/int
import gleam/io
import gleam/list
import gleam/result
import gleam/string
import gleam/pair
import gleam/option.{None, Some}
import gleam/map.{Map}
import utils
import matrix
import grid

fn parse_line(line: String) -> Result(List(Int), String) {
  line
  |> string.to_graphemes
  |> list.map(int.parse)
  |> result.all
  |> result.replace_error("Couldn't parse line")
}

fn read_input(file: String) {
  utils.get_input_lines(file, parse_line)
}

pub fn part1(input) {
  try input = read_input(input)
  let points_map =
    grid.from_matrix(input)
    |> io.debug

  Ok(0)
}

pub fn part1_test() {
  part1("./data/15/test1.txt")
}

pub fn part1_main() {
  part1("./data/15/input.txt")
}
