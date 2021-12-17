import gleam/int
import gleam/io
import gleam/list
import gleam/result
import gleam/string
import gleam/map
import utils

fn read_input(file: String) {
  try content =
    utils.read_file(file)
    |> result.replace_error("Couldn't read file")
  try #(template_block, rules_block) =
    string.split_once(content, "\n\n")
    |> result.replace_error("Couldn't split")
  let template = template_block
  try rules = parse_rules(rules_block)
  Ok(#(template, rules))
}

fn parse_rules(input) {
  try rules =
    input
    |> utils.split_lines
    |> list.map(parse_rule)
    |> result.all

  // |> io.debug
  // Ok(map.from_list(rules))
  Ok(rules)
}

fn parse_rule(input) {
  try #(left, right) =
    string.split_once(input, " -> ")
    |> result.replace_error("Couldn't split")

  let left_chars = parse_rule_left(left)
  let right_chars = string.replace(left_chars, "_", right)

  Ok(#(left_chars, right_chars))
}

fn parse_rule_left(input) {
  string.join(string.to_graphemes(input), "_")
}

fn part1(input) {
  try #(template, rules) = read_input(input)

  let polymer = run_rules(template, rules, 10)

  let score = get_score(polymer)

  Ok(score)
}

fn part2(input) {
  try #(template, rules) = read_input(input)

  let polymer = run_rules(template, rules, 15)

  let score = get_score(polymer)

  Ok(score)
}

fn get_score(output) {
  let counts =
    output
    |> string.to_graphemes
    |> utils.count

  let vals = map.values(counts)
  let min = utils.list_min(vals, 0)
  let max = utils.list_max(vals, 0)
  Ok(max - min)
}

fn run_rules(template, rules, steps_to_go) {
  case steps_to_go {
    0 -> template
    _ -> run_rules(insert(template, rules), rules, steps_to_go - 1)
  }
}

fn insert(template, rules) {
  let with_holes = add_holes(template)

  with_holes
  |> apply_rules(rules)
}

fn add_holes(template) {
  template
  |> string.to_graphemes
  |> list.map(fn(c) { [c, "_"] })
  |> list.flatten
  |> string.join("")
  |> string.drop_right(1)
}

fn apply_rules(with_holes, rules) {
  list.fold(rules, with_holes, apply_rule_twice)
}

fn apply_rule_twice(str, rule) {
  str
  |> apply_rule(rule)
  |> apply_rule(rule)
}

fn apply_rule(str, rule) {
  let #(from, to) = rule
  string.replace(str, from, to)
}

pub fn part1_test() {
  part1("./data/14/test1.txt")
}

pub fn part1_main() {
  part1("./data/14/input.txt")
}

pub fn part2_test() {
  part2("./data/14/test1.txt")
}

pub fn part2_main() {
  part2("./data/14/input.txt")
}
