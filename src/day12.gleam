import gleam/bool
import gleam/int
import gleam/io
import gleam/list
import gleam/map.{Map}
import gleam/option.{None, Some}
import gleam/pair
import gleam/result
import gleam/set.{Set}
import gleam/string
import matrix
import utils

type Graph =
  Map(String, List(String))

fn parse_line(line: String) {
  string.split_once(line, "-")
  |> result.replace_error(line)
}

fn read_input(file: String) {
  utils.get_input_lines(file, parse_line)
  |> result.map(make_graph)
}

fn make_graph(lines) {
  list.fold(
    lines,
    map.new(),
    fn(acc, tuple) {
      let #(a, b) = tuple
      add_bi_to_graph(acc, a, b)
    },
  )
  // From end we cannot go anywhere
  // |> map.delete("end")
  // We don't want to go back to start
  // |> map.map_values(fn(_, v) { remove_start(v) })
}

fn remove_start(l) {
  list.filter(l, is_not_start)
}

fn is_not_start(name) {
  name != "start"
}

fn add_bi_to_graph(graph, a, b) {
  graph
  |> add_to_graph(a, b)
  |> add_to_graph(b, a)
}

fn add_to_graph(graph, from, to) {
  map.update(
    graph,
    from,
    fn(op) {
      case op {
        Some(current) -> [to, ..current]
        None -> [to]
      }
    },
  )
}

pub fn part1(input) {
  try graph =
    read_input(input)
    |> io.debug

  try paths =
    walk([], "start", graph, part1_can_visit)
    |> io.debug

  Ok(list.length(paths))
}

fn part1_can_visit(previous_path, current) {
  case is_lower(current) {
    False -> True
    True ->
      list.contains(previous_path, current)
      |> bool.negate
  }
}

pub fn part2(input) {
  try graph =
    read_input(input)
    |> io.debug

  try paths =
    walk([], "start", graph, part2_can_visit)
    |> io.debug

  Ok(list.length(paths))
}

fn part2_can_visit(previous_path, current) {
  case is_lower(current) {
    False -> True
    True -> {
      let times_walked =
        previous_path
        |> list.filter(fn(p) { p == current })
        |> list.length
      case times_walked {
        0 -> True
        1 ->
          // Can visit if no other lower is twice
          max_lower_count(previous_path) < 2
        _ -> False
      }
    }
  }
}

fn is_lower(c) {
  string.lowercase(c) == c
}

fn max_lower_count(path: List(String)) -> Int {
  path
  |> list.filter(is_lower)
  |> utils.count
  |> map.values
  |> list.reduce(int.max)
  |> result.unwrap(0)
}

// [A c A] is ok
// [A c A c] is not
// lower cannot be two times
fn walk(
  previous_path: List(String),
  from: String,
  graph: Graph,
  can_visit: fn(List(String), String) -> Bool,
) -> Result(List(List(String)), String) {
  let path = list.append(previous_path, [from])
  let is_back_to_start = from == "start" && list.length(previous_path) > 0
  let is_end = from == "end"

  // Start can only be at the beginning
  case is_back_to_start {
    True -> Error("Cannot go back to start")
    False ->
      case is_end {
        True -> Ok([path])
        False ->
          case can_visit(previous_path, from) {
            False -> Ok([path])
            True ->
              // Keep walking
              case map.get(graph, from) {
                Error(_) -> Error("Destination not found")
                Ok(goes_to) -> {
                  let found =
                    list.filter_map(
                      goes_to,
                      fn(to) { walk(path, to, graph, can_visit) },
                    )
                    |> list.flatten
                    // Only keeps the ones that go to the end
                    |> list.filter(fn(path) { list.last(path) == Ok("end") })
                  Ok(found)
                }
              }
          }
      }
  }
}

pub fn part1_test1() {
  part1("./data/12/test1.txt")
}

pub fn part1_test2() {
  part1("./data/12/test2.txt")
}

pub fn part1_test3() {
  part1("./data/12/test3.txt")
}

pub fn part1_main() {
  part1("./data/12/input.txt")
}

pub fn part2_test1() {
  part2("./data/12/test1.txt")
}

pub fn part2_test2() {
  part2("./data/12/test2.txt")
}

pub fn part2_test3() {
  part2("./data/12/test3.txt")
}

pub fn part2_main() {
  part2("./data/12/input.txt")
}
