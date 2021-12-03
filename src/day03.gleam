import gleam/int
import gleam/list
import gleam/result
import gleam/string
import gleam/io
import gleam/bool
import utils

fn parse_bit(char: String) -> Result(Bool, String) {
  case char {
    "0" -> Ok(False)
    "1" -> Ok(True)
    _ -> Error("Invalid bit")
  }
}

fn parse_line(line: String) -> Result(List(Bool), String) {
  line
  |> string.to_graphemes
  |> list.map(parse_bit)
  |> result.all
}

fn read_input(file: String) {
  utils.get_input_lines(file, parse_line)
}

fn most_common(bits: List(Bool)) -> Bool {
  let #(ons, offs) =
    bits
    |> list.partition(fn(b) { b == True })

  list.length(ons) > list.length(offs)
}

fn get_gamma_rate(bits: List(List(Bool))) -> List(Bool) {
  bits
  |> list.transpose
  |> list.map(most_common)
}

fn get_epsilon(gamma: List(Bool)) -> List(Bool) {
  gamma
  |> list.map(bool.negate)
}

pub fn part1(file: String) {
  try input = read_input(file)
  let gamma_rate = get_gamma_rate(input)
  let epsilon_rate = get_epsilon(gamma_rate)
  let gamma = utils.from_binary(gamma_rate)
  let epsilon = utils.from_binary(epsilon_rate)

  Ok(gamma * epsilon)
}
