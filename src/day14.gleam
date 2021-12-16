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
  let template = parse_template(template_block)
  try rules = parse_rules(rules_block)
  Ok(#(template, rules))
}

fn parse_template(input) {
  input
  |> string.to_graphemes
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

  Ok(#(left_chars, right))
}

fn parse_rule_left(input) {
  case string.to_graphemes(input) {
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

fn part2(input) {
  try #(template, rules) = read_input(input)

  let polymer = run(template, rules, 40)

  let counts = utils.count(polymer)

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
  insert_([], template, rules)
}

fn insert_(collected, remainder, rules) {
  case remainder {
    [a, b, ..rest] -> {
      let char_to_insert =
        map.get(rules, #(a, b))
        |> result.unwrap("")
      insert_(list.append(collected, [a, char_to_insert]), [b, ..rest], rules)
    }
    [b] -> list.append(collected, [b])
    _ -> collected
  }
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
