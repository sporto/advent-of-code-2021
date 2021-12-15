import gleam/io
import gleam/list
import gleam/int
import gleam/result
import gleam/string
import gleam/pair
import gleam/option.{None, Some}
import gleam/map.{Map}
import gleam/set.{Set}
import utils
import matrix

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

  let cant_visit = fn(previous_path, current) {
    let walked = list.contains(previous_path, current)
    let is_lower = string.lowercase(current) == current
    walked && is_lower
  }

  try paths =
    walk([], "start", graph, cant_visit)
    |> io.debug

  Ok(list.length(paths))
}

pub fn part2(input) {
  try graph =
    read_input(input)
    |> io.debug

  let cant_visit = fn(previous_path, current) {
    let walked = list.contains(previous_path, current)
    let is_lower = string.lowercase(current) == current
    walked && is_lower
  }

  try paths =
    walk([], "start", graph, cant_visit)
    |> io.debug

  Ok(list.length(paths))
}

// [A c A] is ok
// [A c A c] is not
// lower cannot be two times
fn walk(
  previous_path: List(String),
  from: String,
  graph: Graph,
  cant_visit: fn(List(String), String) -> Bool,
) -> Result(List(List(String)), String) {
  let path = list.append(previous_path, [from])
  let is_back_to_start = from == "start" && list.length(previous_path) > 0
  let is_end = from == "end"
  let cannot_visit = cant_visit(previous_path, from)

  // Start can only be at the beginning
  case is_back_to_start {
    True -> Error("Cannot go back to start")
    False ->
      case is_end {
        True -> Ok([path])
        False ->
          case cannot_visit {
            True -> Ok([path])
            False ->
              // Keep walking
              case map.get(graph, from) {
                Error(_) -> Error("Destination not found")
                Ok(goes_to) -> {
                  let found =
                    list.filter_map(
                      goes_to,
                      fn(to) { walk(path, to, graph, cant_visit) },
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
