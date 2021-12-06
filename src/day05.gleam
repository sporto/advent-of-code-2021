import gleam/int
import gleam/io
import gleam/result
import gleam/string
import utils

type Point {
  Point(x: Int, y: Int)
}

type Vector =
  #(Point, Point)

fn parse_point(input: String) -> Result(Point, String) {
  try #(ix, iy) =
    string.split_once(input, ",")
    |> result.replace_error("Unable to parse point")
  try x =
    int.parse(ix)
    |> result.replace_error("Unable to parse x")
  try y =
    int.parse(iy)
    |> result.replace_error("Unable to parse y")
  let point = Point(x, y)
  Ok(point)
}

fn parse_line(line: String) -> Result(Vector, String) {
  try #(input_p1, input_p2) =
    string.split_once(line, " -> ")
    |> result.replace_error("Unable to parse vector")
  try p1 = parse_point(input_p1)
  try p2 = parse_point(input_p2)
  let vector = #(p1, p2)
  Ok(vector)
}

fn read_input(file: String) {
  utils.get_input_lines(file, parse_line)
}

pub fn part1(file: String) {
  try input = read_input(file)

  io.debug(input)

  Ok(1)
}
