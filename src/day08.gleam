import utils
import gleam/list
import gleam/result
import gleam/io
import gleam/string
import gleam/int
import gleam/pair
import gleam/map.{Map}

pub type Line {
  Line(input: List(String), output: List(String))
}

fn segments() {
  [
    #(0, "acfgeb"),
    #(1, "cf"),
    #(2, "acdeg"),
    #(3, "acdfg"),
    #(4, "bcdf"),
    #(5, "abdfg"),
    #(6, "abdefg"),
    #(7, "acf"),
    #(8, "abcdefg"),
    #(9, "abcdfg"),
  ]
}

fn parse_line(line: String) -> Result(Line, String) {
  try #(in, out) =
    string.split_once(line, " | ")
    |> result.replace_error("Couldn't split")
  let line =
    Line(
      in
      |> string.split(" "),
      out
      |> string.split(" "),
    )
  Ok(line)
}

fn read_input(file: String) {
  utils.get_input_lines(file, parse_line)
}

fn unique_lens() {
  segments()
  |> list.map(pair.second)
  |> list.map(string.length)
  |> utils.count
  |> map.filter(fn(k, v) { v == 1 })
  |> map.keys
}

fn count_unique(segments) {
  let uniq = unique_lens()
  segments
  |> list.map(string.length)
  |> list.filter(fn(n) { list.contains(uniq, n) })
  |> list.length
}

pub fn part1(input) {
  try input = read_input(input)
  // take the output
  // count the segments that are unique
  let sum =
    input
    |> list.map(fn(l: Line) { l.output })
    |> list.map(count_unique)
    |> int.sum
  Ok(sum)
}

pub fn part1_test() {
  part1("./data/08/test.txt")
}

pub fn part1_main() {
  part1("./data/08/input.txt")
}
