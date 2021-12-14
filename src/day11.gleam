import gleam/io
import gleam/list
import gleam/int
import gleam/result
import gleam/string
import utils

fn parse_line(line: String) {
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
  Ok(0)
}

pub fn part2(input) {
  try input = read_input(input)
  Ok(0)
}

pub fn part1_test() {
  part1("./data/11/test.txt")
}

pub fn part1_main() {
  part1("./data/11/input.txt")
}

pub fn part2_test() {
  part2("./data/11/test.txt")
}

pub fn part2_main() {
  part2("./data/11/input.txt")
}
