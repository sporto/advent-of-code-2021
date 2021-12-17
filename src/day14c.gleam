import gleam/int
import gleam/io
import gleam/list
import gleam/result
import gleam/string
import gleam/pair
import gleam/option.{None, Some}
import gleam/map.{Map}
import utils

type Pair =
  #(String, String)

type PairMap =
  Map(Pair, Int)

type Rule =
  #(Pair, List(Pair))

type RuleMap =
  Map(Pair, List(Pair))

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

  try left_pair = parse_left_pair(left)
  let right_pairs = [
    #(pair.first(left_pair), right),
    #(right, pair.second(left_pair)),
  ]

  // let right_chars = intersperse_char(left, right)
  Ok(#(left_pair, right_pairs))
}

fn parse_left_pair(input: String) -> Result(Pair, String) {
  case string.to_graphemes(input) {
    [a, b] -> Ok(#(a, b))
    _ -> Error("Couldn't get pair")
  }
}

fn part1(input) {
  run(input, 10)
}

fn part2(input) {
  // 14 5s
  // 15 8s
  // 16 23s
  run(input, 14)
}

fn run(input, steps) {
  try #(template, rules) = read_input(input)

  let pairs_map = make_pairs_map(template)

  let rules_map = map.from_list(rules)

  try first_char =
    template
    |> list.first
    |> result.replace_error("Couldn't get first")

  let final_pair_map = run_steps(pairs_map, rules_map, steps)

  // |> io.debug
  let element_counts = count_elements(first_char, final_pair_map)

  // |> io.debug
  element_counts
  |> map.values
  |> int.sum

  // |> io.debug
  let vals = map.values(element_counts)

  let min = utils.list_min(vals, 0)

  let max = utils.list_max(vals, 0)

  Ok(max - min)
}

fn count_elements(first_char: String, pairs_map: PairMap) {
  // Pairs share the element, we cannot simply count like this
  map.fold(
    pairs_map,
    map.new(),
    fn(acc, tuple, count) {
      let #(a, b) = tuple

      // Do not count the one on the left as this will be the right of another pair
      acc
      |> utils.update_map_count(b, count)
    },
  )
  |> utils.update_map_count(first_char, 1)
}

fn make_pairs_map(template) -> Map(Pair, Int) {
  template
  |> list.window_by_2
  |> utils.count
}

fn run_steps(pairs_map: PairMap, rules: RuleMap, steps_to_go: Int) {
  case steps_to_go {
    0 -> pairs_map
    _ -> {
      let next_pair_map = run_step(pairs_map, rules)
      run_steps(next_pair_map, rules, steps_to_go - 1)
    }
  }
}

fn run_step(pairs_map: PairMap, rules: RuleMap) {
  run_step_v1(pairs_map, rules)
}

// Fold over a map
fn run_step_v1(pairs_map: PairMap, rules: RuleMap) -> PairMap {
  map.fold(
    pairs_map,
    map.new(),
    fn(acc, pair, count) {
      let pairs =
        map.get(rules, pair)
        |> result.unwrap([])
      // we need to insert new pairs by the # of count
      insert_pairs(acc, pairs, count)
    },
  )
}

// Fold over a list
fn run_step_v2(pairs_map: PairMap, rules: RuleMap) -> PairMap {
  let pairs = map.to_list(pairs_map)
  list.fold(
    pairs,
    map.new(),
    fn(acc, pair_and_count) {
      let #(pair, count) = pair_and_count
      let pairs =
        map.get(rules, pair)
        |> result.unwrap([])
      // we need to insert new pairs by the # of count
      insert_pairs(acc, pairs, count)
    },
  )
}

// Using recursion
fn run_step_v3(pairs_map: PairMap, rules: RuleMap) -> PairMap {
  let pairs = map.to_list(pairs_map)
  run_step_v3_(pairs, rules, map.new())
}

fn run_step_v3_(pairs, rules: RuleMap, acc) -> PairMap {
  case pairs {
    [] -> acc
    [pair_and_count, ..rest] -> {
      let #(pair, count) = pair_and_count
      let pairs =
        map.get(rules, pair)
        |> result.unwrap([])
      // we need to insert new pairs by the # of count
      let next_acc = insert_pairs(acc, pairs, count)
      run_step_v3_(rest, rules, next_acc)
    }
  }
}

fn insert_pairs(pair_map: PairMap, pairs: List(Pair), how_many_times: Int) {
  pairs
  |> list.repeat(how_many_times)
  |> list.flatten
  |> insert_pairs_once(pair_map, _)
}

fn insert_pairs_once(pair_map: PairMap, pairs: List(Pair)) {
  list.fold(
    pairs,
    pair_map,
    fn(acc, pair) { utils.update_map_count(acc, pair, 1) },
  )
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
