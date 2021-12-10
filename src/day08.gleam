import utils
import gleam/list
import gleam/result
import gleam/io
import gleam/string
import gleam/int
import gleam/set
import gleam/pair
import gleam/bool
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

fn resolve_line_output(l: Line) -> Result(Int, String) {
  let all = list.append(l.input, l.output)
  // resolve(all, map.new())
  let matches =
    all
    |> list.sort(string.compare)
    |> list.unique
    |> list.map(segment_matches)

  // |> io.debug
  let uniques =
    matches
    |> find_uniques

  let known =
    uniques
    |> map.values()

  // |> io.debug
  // |> list.map(what_cannot_be)
  // |> list.flatten
  // |> io.debug
  // reduce(matches, map.new())
  // |> io.debug
  try one =
    map.get(uniques, 1)
    |> result.replace_error("Couldn't find 1")
  try four =
    map.get(uniques, 7)
    |> result.replace_error("Couldn't find 7")
  try seven =
    map.get(uniques, 7)
    |> result.replace_error("Couldn't find 7")
  try eight =
    map.get(uniques, 8)
    |> result.replace_error("Couldn't find 8")

  let remainder =
    matches
    |> list.filter(fn(m) {
      list.contains(known, pair.first(m))
      |> bool.negate
    })

  // Given 1 and 7 we can find segment A
  try a = find_segment_a(one, seven)

  // |> io.debug
  // We can find using 1
  // try two = 
  //   find_two(one, )
  // Knowing A we can find 4
  // try four =
  //   find_four(remainder, a)
  //   |> io.debug
  Ok(0)
}

fn find_segment_a(one, seven) {
  // Segment that doesn't appear in one
  find_segment_diff(seven, one)
  |> Ok
}

// fn find_four(lookup, a: String) {
//   // 4 is the only one without a
//   io.debug(a)
//   lookup
//   |> io.debug
//   |> list.find(fn(t) {
//     string.contains(pair.first(t), a)
//     |> bool.negate
//   })
//   |> result.replace_error("Couldn't find 4")
// }
fn find_segment_diff(bigger, smaller) -> String {
  let bigger_set =
    string.to_graphemes(bigger)
    |> set.from_list
  let smaller_set =
    string.to_graphemes(smaller)
    |> set.from_list

  let all = set.union(bigger_set, smaller_set)
  let intersection = set.intersection(bigger_set, smaller_set)
  let diff =
    set.fold(
      over: all,
      from: set.new(),
      with: fn(acc, member) {
        case set.contains(intersection, member) {
          True -> acc
          False -> set.insert(acc, member)
        }
      },
    )
  diff
  |> set.to_list
  |> string.join("")
}

fn find_uniques(all_matches) {
  // 4 uniques
  // 1 -> 2 chars
  // 4 -> 4 chars
  // 7 -> 3 chars
  // 8 -> 7 chars
  list.fold(
    over: all_matches,
    from: map.new(),
    with: fn(acc, tup: #(String, List(Digit))) {
      let #(seq, digits) = tup
      case digits {
        [one] -> map.insert(acc, one.n, seq)
        _ -> acc
      }
    },
  )
}

fn segment_matches(segment: String) -> #(String, List(Digit)) {
  // Find all the segments that match
  let len = string.length(segment)
  let matches =
    digits
    |> list.filter(fn(dig: Digit) {
      dig.segs
      |> list.length == len
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
  try sum =
    input
    |> list.map(resolve_line_output)
    |> result.all
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
