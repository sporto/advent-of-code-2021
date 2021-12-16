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
  try rules =
    input
    |> utils.split_lines
    |> list.map(parse_rule)
    |> result.all

  Ok(map.from_list(rules))
}

fn parse_rule(input) {
  try #(left, right) =
    string.split_once(input, " -> ")
    |> result.replace_error("Couldn't split")

  try left_chars = parse_rule_left(left)

  try right_char = parse_char(right)

  Ok(#(left_chars, right_char))
}

fn parse_rule_left(input) {
  try left_chars =
    input
    |> string.to_graphemes
    |> list.map(parse_char)
    |> result.all

  case left_chars {
    [a, b] -> Ok(#(a, b))
    _ -> Error("Invalid")
  }
}

fn part1(input) {
  try #(template, rules) = read_input(input)

  let polymer = run(template, rules, 10)

  let counts = utils.count(polymer)

  // |> io.debug
  let vals = map.values(counts)

  let min = utils.list_min(vals, 0)
  let max = utils.list_max(vals, 0)

  Ok(max - min)
}

fn run(template, rules, steps_to_go) {
  case steps_to_go {
    0 -> template
    _ -> run(insert(template, rules), rules, steps_to_go - 1)
  }
}

fn insert(template, rules) {
  template
  |> list.window_by_2
  |> list.map(insert_in_pair(_, rules))
  |> result.all
  |> result.map(compress)
  |> result.unwrap([])
}

fn insert_in_pair(tuple, rules) {
  let #(a, b) = tuple

  map.get(rules, tuple)
  |> result.map(fn(insertion) { #(a, insertion, b) })
}

fn compress(tuples) {
  let head =
    list.take(tuples, 1)
    |> list.map(fn(tuple) {
      let #(a, b, c) = tuple
      [a, b, c]
    })
    |> list.flatten

  let tail =
    tuples
    |> list.drop(1)
    |> list.map(fn(tuple) {
      let #(a, b, c) = tuple
      [b, c]
    })
    |> list.flatten

  list.append(head, tail)
}

pub fn part1_test1() {
  part1("./data/14/test1.txt")
}
