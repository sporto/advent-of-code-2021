import gleam/int
import gleam/io
import gleam/list
import gleam/result
import gleam/string
import gleam/pair
import gleam/option.{None, Some}
import gleam/map.{Map}
import utils
import matrix
import grid.{Grid, Point}

type PointAndScore =
  #(Point, Int)

type Path {
  PathInProgress(List(PointAndScore))
  PathInDone(List(PointAndScore))
}

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
  let points_grid = grid.from_matrix(input)
  let end_point = grid.get_bottom_right(points_grid)

  // |> io.debug
  try found_paths = walk([PathInProgress([])], points_grid, end_point)

  // |> io.debug
  // |> io.debug
  io.debug(list.length(found_paths))

  let scores =
    found_paths
    |> list.map(get_path_score)

  let min_score = utils.list_min(scores, 0)

  Ok(min_score)
}

fn walk(walked_paths: List(Path), points_grid, end_point) {
  case walked_paths {
    [] -> Error("Empty paths")
    _ -> {
      // Walk all the walked paths
      try next_walked_paths =
        list.map(walked_paths, walk_one(_, points_grid, end_point))
        // |> io.debug
        |> result.all
      let paths =
        next_walked_paths
        |> list.flatten
        |> keep_low_paths
      // let paths =
      //   next_walked_paths
      case has_paths_in_progress(paths) {
        True -> walk(paths, points_grid, end_point)
        False -> Ok(paths)
      }
    }
  }
  // Ok([])
}

fn has_paths_in_progress(paths) {
  list.any(paths, is_path_in_progress)
}

fn is_path_in_progress(path) {
  case path {
    PathInProgress(_) -> True
    _ -> False
  }
}

fn walk_one(path: Path, points_grid, end_point) -> Result(List(Path), String) {
  case path {
    PathInDone(_) -> Ok([path])
    PathInProgress(walked_path) ->
      // Take the first one and walk all points from there
      // Except the one it came from
      case walked_path {
        [] -> walk_first_point(points_grid)
        [current, ..rest] -> {
          // TODO is current is the last, then we are done
          // Only walked one
          let #(current_point, _) = current
          case current_point == end_point {
            True -> Ok([PathInDone(walked_path)])
            False -> {
              let points_around =
                grid.straight_points_around(points_grid, current_point)
                |> list.filter(only_down_or_right(current, _))
              //
              let paths =
                list.map(
                  points_around,
                  fn(p) { PathInProgress([p, ..walked_path]) },
                )
              Ok(paths)
            }
          }
        }
      }
  }
}

fn only_down_or_right(current: PointAndScore, p: PointAndScore) {
  let #(#(cx, cy), _) = current
  let #(#(x, y), _) = p
  x > cx || y > cy
}

fn keep_low_paths(paths: List(Path)) -> List(Path) {
  let scores =
    paths
    |> list.map(get_path_score)
  let min = utils.list_min(scores, 0)
  paths
  |> list.filter(fn(path) { get_path_score(path) < min + 3 })
}

fn get_path_score(path: Path) {
  let p = case path {
    PathInProgress(p) -> p
    PathInDone(p) -> p
  }
  p
  |> list.reverse
  // Don't count the starting position
  |> list.drop(1)
  |> list.map(pair.second)
  |> int.sum
}

fn walk_first_point(points_grid: Grid(Int)) -> Result(List(Path), String) {
  // io.debug("walk_first_point")
  let point = #(0, 0)
  // Just pick the first one
  try top_left_score =
    map.get(points_grid, point)
    |> result.replace_error("Couldn't not get first point")

  Ok([PathInProgress([#(point, top_left_score)])])
}

pub fn part1_test() {
  part1("./data/15/test1.txt")
}

pub fn part1_main() {
  part1("./data/15/input.txt")
}
