import gleam/int
import gleam/io
import gleam/list
import gleam/result
import gleam/string
import gleam/map.{Map}
import utils

type Rule =
  #(String, String)

type Expansions =
  Map(#(String, Int), String)

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

fn parse_rules(input) -> Result(List(Rule), String) {
  try rules =
    input
    |> utils.split_lines
    |> list.map(parse_rule)
    |> result.all

  Ok(rules)
}

fn parse_rule(input) -> Result(Rule, String) {
  try #(left, right) =
    string.split_once(input, " -> ")
    |> result.replace_error("Couldn't split")

  // let right_chars = intersperse_char(left, right)
  Ok(#(left, right))
}

fn intersperse_char(str, char) {
  str
  |> string.to_graphemes
  |> string.join(char)
}

fn part1(input) {
  try #(template, rules) = read_input(input)

  let expansions =
    create_expansions_up_to(rules, 15)
    |> io.debug

  // let polymer = run(template, rules, 10)
  // let counts = utils.count(polymer)
  // // |> io.debug
  // let vals = map.values(counts)
  // let min = utils.list_min(vals, 0)
  // let max = utils.list_max(vals, 0)
  // Ok(max - min)
  Ok(0)
}

fn part2(input) {
  try #(template, rules) = read_input(input)

  // let polymer = run(template, rules, 40)
  // let counts = utils.count(polymer)
  // let vals = map.values(counts)
  // let min = utils.list_min(vals, 0)
  // let max = utils.list_max(vals, 0)
  // Ok(max - min)
  Ok(0)
}

fn create_expansions_up_to(rules, to_step) {
  create_expansions_up_to_(rules, 1, to_step, map.new())
}

fn create_expansions_up_to_(
  rules: List(Rule),
  current_step: Int,
  to_step: Int,
  expansions: Expansions,
) -> Result(Expansions, String) {
  case current_step > to_step {
    True -> Ok(expansions)
    False -> {
      try next_expansions = create_expansions(rules, current_step, expansions)
      create_expansions_up_to_(
        rules,
        current_step + 1,
        to_step,
        next_expansions,
      )
    }
  }
}

fn create_expansions(
  rules,
  step: Int,
  expansions: Expansions,
) -> Result(Expansions, String) {
  list.try_fold(
    rules,
    expansions,
    fn(acc, rule) {
      let #(from, to) = rule
      let entry = #(from, step)
      case step {
        1 -> {
          // First expansion
          let expansion = expand(from, rules)
          // io.debug("first expansion")
          // io.debug(expansion)
          let next_acc = map.insert(acc, entry, expansion)
          Ok(next_acc)
        }
        _ -> {
          let previous_entry = #(from, step - 1)
          try last_expansion =
            map.get(acc, previous_entry)
            |> result.replace_error("Couldn't get expansion")
          // io.debug(last_expansion)
          let expansion = expand(last_expansion, rules)
          // io.debug(expansion)
          let next_acc = map.insert(acc, entry, expansion)
          Ok(next_acc)
        }
      }
    },
  )
}

// fn run(template, rules, steps_to_go) {
//   case steps_to_go {
//     0 -> template
//     _ -> run(insert(template, rules), rules, steps_to_go - 1)
//   }
// }
// Expand an string once (insert chars in the gaps)
fn expand(string: String, rules: List(Rule)) -> String {
  let rules_map = map.from_list(rules)
  let chars = string.to_graphemes(string)
  expand_([], chars, rules_map)
  |> list.reverse
  |> string.join("")
}

fn expand_(collected: List(String), remainder: List(String), rules_map) {
  case remainder {
    [a, b, ..rest] -> {
      let lookup =
        [a, b]
        |> string.join("")
      let char_to_insert =
        map.get(rules_map, lookup)
        |> result.unwrap("")
      // io.debug("char_to_insert")
      // io.debug(char_to_insert)
      expand_([char_to_insert, a, ..collected], [b, ..rest], rules_map)
    }
    [b] -> [b, ..collected]
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
