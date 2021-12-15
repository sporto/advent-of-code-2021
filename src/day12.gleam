import gleam/io
import gleam/list
import gleam/int
import gleam/result
import gleam/string
import gleam/pair
import gleam/option.{None, Some}
import gleam/map
import utils
import matrix

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
  try input =
    read_input(input)
    |> io.debug

  Ok(0)
}

pub fn part1_test() {
  part1("./data/12/test.txt")
}

pub fn part1_main() {
  part1("./data/12/input.txt")
}
