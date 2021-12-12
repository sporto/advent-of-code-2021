import utils
import gleam/list
import gleam/result
import gleam/io
import gleam/string
import gleam/int
import gleam/set.{Set}
import gleam/pair
import gleam/bool
import gleam/option.{None, Option, Some}
import gleam/map.{Map}

pub type Line {
  Line(input: List(String), output: List(String))
}

// Bit Map
// 
//  aaaa 1
// b 2  c 3
// b    c
//  dddd 4
// e 5  f 6
// e    f
//  gggg 7
//
//
type Seg {
  A
  B
  C
  D
  E
  F
  G
}

type Digit {
  Digit(n: Int, segs: List(Seg))
}

fn get_digit_segments(dig: Digit) -> List(Seg) {
  dig.segs
}

const digits = [
  Digit(0, [A, B, C, E, F, G]),
  Digit(1, [C, F]),
  Digit(2, [A, C, D, E, G]),
  Digit(3, [A, C, D, F, G]),
  Digit(4, [B, C, D, F]),
  Digit(5, [A, B, D, F, G]),
  Digit(6, [A, B, D, E, F, G]),
  Digit(7, [A, C, F]),
  Digit(8, [A, B, C, D, E, F, G]),
  Digit(9, [A, B, C, D, F, G]),
]

const segments = [A, B, C, D, E, F, G]

fn all_segments() {
  [A, B, C, D, E, F, G]
  |> set.from_list
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

// PART 1
fn unique_lens() {
  digits
  |> list.map(get_digit_segments)
  |> list.map(list.length)
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

// PART 2
fn resolve_line_output(l: Line) -> Result(Int, String) {
  let all = list.append(l.input, l.output)

  let segments =
    all
    |> list.sort(string.compare)
    |> list.unique
    |> list.map(seg_to_set)

  // 1
  try one = find_with_len(segments, 2)

  // 4
  try four = find_with_len(segments, 4)

  let l_in_four = utils.set_diff(four, one)

  try mapping_list =
    list.try_map(
      segments,
      fn(seg) {
        try n = find_num(seg, one, l_in_four)
        Ok(#(seg, n))
      },
    )

  let mapping = map.from_list(mapping_list)

  try digits =
    l.output
    |> list.map(seg_to_set)
    |> list.try_map(fn(sequence) {
      map.get(mapping, sequence)
      |> result.replace_error("Couldn't find the n")
    })

  digits
  |> list.map(int.to_string)
  |> string.join("")
  |> int.parse
  |> result.replace_error("Couldn't parse")
}

fn seg_to_set(seg: String) -> Set(String) {
  seg
  |> string.to_graphemes
  |> set.from_list
}

fn find_with_len(segments, len) {
  list.find(segments, fn(seg) { set.size(seg) == len })
  |> result.replace_error("Couldn't find")
}

fn find_num(seg, one, l_in_four) {
  case set.size(seg) {
    2 -> Ok(1)
    3 -> Ok(7)
    4 -> Ok(4)
    5 ->
      // Either 2 3 5
      case utils.set_includes(seg, one) {
        True -> Ok(3)
        False ->
          case utils.set_includes(seg, l_in_four) {
            True -> Ok(5)
            False -> Ok(2)
          }
      }
    6 ->
      // Either 0 6 9
      case utils.set_includes(seg, l_in_four) {
        True ->
          case utils.set_includes(seg, one) {
            True -> Ok(9)
            False -> Ok(6)
          }
        False -> Ok(0)
      }
    7 -> Ok(8)
    _ -> Error("Unexpected len")
  }
}

pub fn part2(input: String) {
  try input = read_input(input)
  try sum =
    input
    |> list.map(resolve_line_output)
    |> result.all
    |> io.debug
    |> result.map(int.sum)
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
