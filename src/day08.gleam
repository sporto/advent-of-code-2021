import utils
import gleam/list
import gleam/result
import gleam/io
import gleam/string

pub type Line {
  Line(input: List(String), output: List(String))
}

fn parse_line(line: String) -> Result(Line, String) {
  try #(in, out) =
    string.split_once(line, " | ")
    |> result.replace_error("Couldn't split")
  let line =
    Line(
      in
      |> string.split(" "),
      out
      |> string.split(" "),
    )
  Ok(line)
}

fn read_input(file: String) {
  utils.get_input_lines(file, parse_line)
}

pub fn part1(input) {
  try input = read_input(input)
  Ok(input)
}

pub fn part1_test() {
  part1("./data/08/test.txt")
}
