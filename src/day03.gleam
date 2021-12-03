import gleam/int
import gleam/list
import gleam/result
import gleam/string
import gleam/io
import gleam/bool
import utils

type Matrix =
  List(List(Bool))

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

  list.length(ons) >= list.length(offs)
}

fn get_most_common_bits(bits: Matrix) -> List(Bool) {
  bits
  |> list.transpose
  |> list.map(most_common)
}

fn get_bit_in_col(bits: List(Bool), col: Int) -> Bool {
  bits
  |> list.at(col)
  |> result.unwrap(False)
}

fn get_most_common_bit_in_col(matrix: Matrix, col: Int) -> Bool {
  matrix
  |> list.map(fn(bit) { get_bit_in_col(bit, col) })
  |> most_common
}

fn get_least_common_bit_in_col(matrix: Matrix, col: Int) -> Bool {
  get_most_common_bit_in_col(matrix, col)
  |> bool.negate
}

fn negate_bits(bits: List(Bool)) -> List(Bool) {
  bits
  |> list.map(bool.negate)
}

pub fn part1(file: String) {
  try input = read_input(file)
  let gamma_rate = get_most_common_bits(input)
  let epsilon_rate = negate_bits(gamma_rate)
  let gamma = utils.binary_to_int(gamma_rate)
  let epsilon = utils.binary_to_int(epsilon_rate)

  Ok(gamma * epsilon)
}

fn filter_row(bits: List(Bool), col: Int, target: Bool) -> Bool {
  list.at(bits, col) == Ok(target)
}

fn search(matrix: Matrix, col: Int, criteria) {
  let target_bit = criteria(matrix, col)

  let filtered =
    matrix
    |> list.filter(fn(bits) { filter_row(bits, col, target_bit) })

  // filtered
  // |> list.map(utils.binary_to_string)
  // |> io.debug
  case filtered {
    [] -> []
    [one] -> one
    many -> search(filtered, col + 1, criteria)
  }
}

fn get_oxygen_generator_rating(matrix: Matrix) {
  search(matrix, 0, get_most_common_bit_in_col)
}

fn get_co2_scrubber_rating(matrix: Matrix) {
  search(matrix, 0, get_least_common_bit_in_col)
}

pub fn part2(file: String) {
  try input = read_input(file)

  let oxygen = get_oxygen_generator_rating(input)
  // io.debug(
  //   oxygen
  //   |> utils.binary_to_string,
  // )
  let co2_scrubber = get_co2_scrubber_rating(input)
  // io.debug(
  //   co2_scrubber
  //   |> utils.binary_to_string,
  // )
  let oxygen_int = utils.binary_to_int(oxygen)
  let co2_scrubber_int = utils.binary_to_int(co2_scrubber)
  Ok(oxygen_int * co2_scrubber_int)
}
