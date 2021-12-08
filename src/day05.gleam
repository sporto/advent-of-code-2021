import gleam/int
import gleam/io
import gleam/result
import gleam/list
import gleam/string
import gleam/set
import gleam/bool
import gleam/option.{None, Some}
import gleam/map.{Map}
import utils

pub type Point {
  Point(x: Int, y: Int)
}

pub type Line =
  #(Point, Point)

fn get_x(point: Point) {
  point.x
}

fn get_y(point: Point) {
  point.y
}

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

fn parse_line(line: String) -> Result(Line, String) {
  try #(input_p1, input_p2) =
    string.split_once(line, " -> ")
    |> result.replace_error("Unable to parse line")
  try p1 = parse_point(input_p1)
  try p2 = parse_point(input_p2)
  let line = #(p1, p2)
  Ok(line)
}

fn read_input(file: String) {
  utils.get_input_lines(file, parse_line)
}

type Grid =
  Map(Point, Int)

fn is_hor(line: Line) {
  let #(a, b) = line
  a.y == b.y
}

fn is_ver(line: Line) {
  let #(a, b) = line
  a.x == b.x
}

fn is_horizontal_or_vertical(line: Line) {
  is_hor(line) || is_ver(line)
}

fn walk_line(acc: List(Point), current_point: Point, end_point: Point) {
  let move = fn(current, towards) {
    case current == towards {
      True -> current
      False ->
        case current < towards {
          True -> current + 1
          False -> current - 1
        }
    }
  }
  case current_point == end_point {
    True -> [end_point, ..acc]
    False -> {
      let next_x = move(current_point.x, end_point.x)
      let next_y = move(current_point.y, end_point.y)
      let next_point = Point(next_x, next_y)
      walk_line([current_point, ..acc], next_point, end_point)
    }
  }
}

pub fn points_in_line(line: Line) -> List(Point) {
  let #(a, b) = line
  walk_line([], a, b)
}

fn build_grid(lines: List(Line), line_filter) -> Grid {
  // collect all points for the lines
  let all_points =
    lines
    |> list.filter(line_filter)
    |> list.map(points_in_line)
    |> list.flatten

  list.fold(over: all_points, from: map.new(), with: add_point_to_grid)
}

fn add_point_to_grid(grid: Grid, point: Point) {
  map.update(
    grid,
    update: point,
    with: fn(op) {
      case op {
        None -> 1
        Some(val) -> val + 1
      }
    },
  )
}

fn run(file: String, line_filter) {
  try input = read_input(file)

  let grid = build_grid(input, line_filter)

  let with_2_or_more =
    grid
    |> map.values
    |> list.filter(fn(n) { n >= 2 })
    |> list.length

  Ok(with_2_or_more)
}

pub fn part1(file: String) {
  run(file, is_horizontal_or_vertical)
}

pub fn part2(file: String) {
  run(file, fn(l) { True })
}
