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
  |> result.map(make_map)
}

fn make_map(lines) {
  list.fold(
    lines,
    map.new(),
    fn(acc, tuple) {
      let #(from, to) = tuple
      map.update(
        acc,
        from,
        fn(op) {
          case op {
            Some(current) -> [to, ..current]
            None -> [to]
          }
        },
      )
    },
  )
}

pub fn part1(input) {
  try graph = read_input(input)

  let paths =
    find_paths(graph)
    |> io.debug

  Ok(0)
}

fn find_paths(graph) {
  graph
  |> map.to_list
  |> list.reverse
  |> list.fold(
    map.new(),
    fn(paths_found, tuple) {
      let #(from, _) = tuple
      let paths = walk(from, graph, paths_found)
      map.insert(paths_found, from, paths)
    },
  )
}

fn walk(from: String, graph: Graph, paths_found) -> List(List(String)) {
  case map.get(paths_found, from) {
    Ok(found) -> found
    Error(_) ->
      // io.debug(from)
      case map.get(graph, from) {
        Error(Nil) -> [[from]]
        Ok(tos) ->
          // io.debug(tos)
          list.map(tos, walk(_, graph, paths_found))
          |> list.flatten
          |> list.map(fn(l) { [from, ..l] })
      }
  }
}

pub fn part1_test() {
  part1("./data/12/test.txt")
}

pub fn part1_main() {
  part1("./data/12/input.txt")
}
