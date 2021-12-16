import gleam/int
import gleam/io
import gleam/list
import gleam/result
import gleam/string
import gleam/map
import utils

type Pol {
  B
  C
  H
  N
}

fn read_input(file: String) {
  try content =
    utils.read_file(file)
    |> result.replace_error("Couldn't read file")
  try #(template_block, rules_block) =
    string.split_once(content, "\n\n")
    |> result.replace_error("Couldn't split")
  try template = parse_template(template_block)
  try rules = parse_rules(rules_block)
  Ok(#(template, rules))
}

fn parse_template(input) {
  input
  |> string.to_graphemes
  |> list.map(parse_char)
  |> result.all
}

fn parse_char(c) {
  case c {
    "B" -> Ok(B)
    "C" -> Ok(C)
    "H" -> Ok(H)
    "N" -> Ok(N)
    _ -> Error(c)
  }
}

fn parse_rules(input) {
  input
  |> utils.split_lines
  |> list.map(parse_rule)
  |> result.all
}

fn parse_rule(input) {
  try #(left, right) =
    string.split_once(input, " -> ")
    |> result.replace_error("Couldn't split")

  try left_chars =
    left
    |> string.to_graphemes
    |> list.map(parse_char)
    |> result.all

  try right_char = parse_char(right)

  Ok(#(left_chars, right_char))
}

fn part1(input) {
  try #(template, rules) =
    read_input(input)
    |> io.debug

  Ok(0)
}

pub fn part1_test1() {
  part1("./data/14/test1.txt")
}
