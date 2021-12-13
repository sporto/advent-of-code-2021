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
import matrix

type Point =
  #(Int, Int)

type PointMap =
  Map(Point, Int)

fn parse_line(line: String) -> Result(List(Int), String) {
  line
  |> string.to_graphemes
  |> list.map(int.parse)
  |> result.all
  |> result.replace_error("Couldn't parse line")
}

fn read_input(file: String) {
  utils.get_input_lines(file, parse_line)
}

pub fn part1(input) {
  try input = read_input(input)
  let points_map = matrix.to_map(input)

  let risk_levels =
    map.map_values(
      points_map,
      fn(point, elevation) {
        let points = points_around(points_map, point)
        let min_elevation =
          points
          |> list.map(pair.second)
          |> utils.list_min(elevation + 1)
        case elevation < min_elevation {
          True -> elevation + 1
          False -> 0
        }
      },
    )

  let result =
    risk_levels
    |> map.values
    |> int.sum
  Ok(result)
}

fn points_around(points_map: PointMap, point: Point) -> List(#(Point, Int)) {
  let #(x, y) = point
  [#(x - 1, y), #(x, y + 1), #(x + 1, y), #(x, y - 1)]
  |> list.filter_map(fn(p: Point) {
    case map.get(points_map, p) {
      Ok(el) -> Ok(#(p, el))
      Error(_) -> Error(Nil)
    }
  })
}

pub fn part1_test() {
  part1("./data/09/test.txt")
}
