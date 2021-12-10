import utils
import gleam/list
import gleam/result
import gleam/io
import gleam/string
import gleam/int
import gleam/pair
import gleam/bool
import gleam/map.{Map}

pub type Line {
  Line(input: List(String), output: List(String))
}

fn segments() {
  [
    #(0, "ABCEFG"),
    #(1, "CF"),
    #(2, "ACDEG"),
    #(3, "ACDFG"),
    #(4, "BCDF"),
    #(5, "ABDFG"),
    #(6, "ABDEFG"),
    #(7, "ACF"),
    #(8, "ABCDEFG"),
    #(9, "ABCDFG"),
  ]
}

const chars = ["A", "B", "C", "D", "E", "F", "G"]

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

fn resolve_line_output(l: Line) {
  let all = list.append(l.input, l.output)
  // resolve(all, map.new())
  let matches =
    all
    |> list.sort(string.compare)
    |> list.unique
    |> list.map(segment_matches)
    // |> list.map(what_cannot_be)
    // |> list.flatten
    // |> io.debug
    // reduce(matches, map.new())
    |> io.debug
  0
}

fn segment_matches(segment: String) {
  // Find all the segments that match
  let len = string.length(segment)
  let matches =
    segments()
    |> list.filter(fn(seg) {
      seg
      |> pair.second
      |> string.length == len
    })

  #(segment, matches)
}

// fn what_cannot_be(t) {
//   let #(segment, matches) = t
//   let seg_chars = string.to_graphemes(segment)
//   let all_match_chars =
//     string.join(matches, "")
//     |> string.to_graphemes
//     |> list.unique
//   let not_matched =
//     chars
//     |> list.filter(fn(c) {
//       list.contains(all_match_chars, c)
//       |> bool.negate
//     })
//   seg_chars
//   |> list.map(fn(c) { #(c, not_matched) })
// }
pub fn part2(input: String) {
  try input = read_input(input)
  let sum =
    input
    |> list.map(resolve_line_output)
    |> int.sum
  Ok(sum)
}

pub fn part1_test() {
  part1("./data/08/test.txt")
}

pub fn part1_main() {
  part1("./data/08/input.txt")
}

pub fn part2_test() {
  part2("./data/08/test.txt")
}

pub fn part2_mini() {
  part2("./data/08/test_one.txt")
}
