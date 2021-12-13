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

pub fn part2(input) {
  try input = read_input(input)
  let points_map = matrix.to_map(input)
  // Find the lowest points
  let lowest =
    map.filter(
      points_map,
      fn(point, elevation) {
        let points = points_around(points_map, point)
        let min_elevation =
          points
          |> list.map(pair.second)
          |> utils.list_min(elevation + 1)
        elevation < min_elevation
      },
    )

  let basins = map.map_values(lowest, fn(p, e) { find_basin(points_map, p) })

  // |> io.debug
  // Keep the three largest
  let results =
    basins
    |> map.values
    |> list.map(set.size)
    |> list.sort(int.compare)
    |> list.reverse
    |> list.take(3)
    |> io.debug

  Ok(list.fold(results, 1, fn(a, b) { a * b }))
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

fn find_basin(points_map: PointMap, point: Point) -> Set(Point) {
  find_basin_rec(points_map, [point], set.new())
}

fn find_basin_rec(
  points_map: Map(Point, Int),
  points: List(Point),
  found: Set(Point),
) -> Set(Point) {
  case points {
    [] -> found
    [first, ..rest] -> {
      let inspected = set.contains(found, first)
      case inspected {
        True -> find_basin_rec(points_map, rest, found)
        False -> {
          let maybe_elevation = map.get(points_map, first)
          case maybe_elevation {
            Ok(elevation) ->
              case elevation < 9 {
                True -> {
                  let next_found = set.insert(found, first)
                  let surrounding_points =
                    points_around(points_map, first)
                    |> list.map(pair.first)
                  find_basin_rec(
                    points_map,
                    list.append(surrounding_points, rest),
                    next_found,
                  )
                }
                False -> find_basin_rec(points_map, rest, found)
              }
            Error(Nil) -> find_basin_rec(points_map, rest, found)
          }
        }
      }
    }
  }
}

pub fn part1_test() {
  part1("./data/09/test.txt")
}

pub fn part1_main() {
  part1("./data/09/input.txt")
}

pub fn part2_test() {
  part2("./data/09/test.txt")
}

pub fn part2_main() {
  part2("./data/09/input.txt")
}
