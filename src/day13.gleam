import gleam/int
import gleam/io
import gleam/list
import gleam/result
import gleam/string
import utils

fn read_input(file: String) {
  try content =
    utils.read_file(file)
    |> result.replace_error("Couldn't read file")
  try #(matrix_block, instructions_block) =
    string.split_once(content, "\n\n")
    |> result.replace_error("Couldn't split")
  try matrix = read_matrix_lines(matrix_block)
  try instructions = read_instructions(instructions_block)
  Ok(#(matrix, instructions))
}

fn read_matrix_lines(input: String) {
  input
  |> utils.split_lines
  |> list.map(parse_matrix_line)
  |> result.all
}

fn parse_matrix_line(line: String) {
  try #(xs, ys) =
    string.split_once(line, ",")
    |> result.replace_error("Couldn't split")

  try x =
    int.parse(xs)
    |> result.replace_error("Couldn't parse")

  try y =
    int.parse(ys)
    |> result.replace_error("Couldn't parse")

  let coor = #(x, y)
  Ok(coor)
}

fn read_instructions(lines: String) {
  lines
  |> utils.split_lines
  |> list.map(read_instruction)
  |> result.all
}

fn read_instruction(line: String) {
  try #(left, right) =
    string.split_once(line, "=")
    |> result.replace_error("Couldn't split")

  let direction =
    left
    |> string.replace("fold along ", "")

  try amount =
    int.parse(right)
    |> result.replace_error("Couldn't parse")

  let ins = #(direction, amount)
  Ok(ins)
}

fn part1(input) {
  try #(matrix, instructions) =
    read_input(input)
    |> io.debug

  Ok(0)
}

pub fn part1_test1() {
  part1("./data/13/test1.txt")
}
