import gleam/int
import gleam/io
import gleam/result
import gleam/list
import gleam/string
import gleam/bool
import gleam/option.{None, Some}
import gleam/map.{Map}
import utils

type Point {
  Point(x: Int, y: Int)
}

type Line =
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

fn add_point(grid: Grid, point: Point) -> Grid {
  map.update(
    in: grid,
    update: point,
    with: fn(opt) {
      case opt {
        Some(i) -> i + 1
        None -> 1
      }
    },
  )
}

fn get_line_min_x(l: Line) -> Int {
  let #(p1, p2) = l
  int.min(p1.x, p2.x)
}

fn get_line_min_y(l: Line) -> Int {
  let #(p1, p2) = l
  int.min(p1.y, p2.y)
}

fn get_line_max_x(l: Line) -> Int {
  let #(p1, p2) = l
  int.max(p1.x, p2.x)
}

fn get_line_max_y(l: Line) -> Int {
  let #(p1, p2) = l
  int.max(p1.y, p2.y)
}

fn add_line_hv(max_point: Point, grid: Grid, line: Line) -> Grid {
  // map values on the given line
  let x_range = list.range(get_line_min_x(line), get_line_max_x(line) + 1)
  let y_range = list.range(get_line_min_y(line), get_line_max_y(line) + 1)

  utils.fold_ranges(
    xs: x_range,
    ys: y_range,
    from: grid,
    with: fn(acc, coor) {
      let #(x, y) = coor
      let point = Point(x, y)
      case line_contains_hv(line, point) {
        True ->
          map.update(
            acc,
            update: point,
            with: fn(op) {
              case op {
                None -> 1
                Some(val) -> val + 1
              }
            },
          )
        False -> acc
      }
    },
  )
}

fn is_hor(line: Line) {
  let #(a, b) = line
  a.y == b.y
}

fn is_ver(line: Line) {
  let #(a, b) = line
  a.x == b.x
}

fn line_contains_hv(line: Line, c: Point) -> Bool {
  case is_hor(line) || is_ver(line) {
    True -> line_contains(line, c)
    False -> False
  }
}

fn line_contains(line: Line, c: Point) -> Bool {
  let #(a, b) = line
  //
  let crossproduct =
    { c.y - a.y } * { b.x - a.x } - { c.x - a.x } * { b.y - a.y }
  let dotproduct = { c.x - a.x } * { b.x - a.x } + { c.y - a.y } * { b.y - a.y }
  let squaredlengthba =
    { b.x - a.x } * { b.x - a.x } + { b.y - a.y } * { b.y - a.y }
  //
  let cond_crossproduct =
    { int.absolute_value(crossproduct) != 0 }
    |> bool.negate
  let cond_dotproduct =
    { dotproduct < 0 }
    |> bool.negate
  let cond_squared =
    { dotproduct > squaredlengthba }
    |> bool.negate

  //
  cond_crossproduct && cond_dotproduct && cond_squared
}

fn line_to_points(l: Line) -> List(Point) {
  let #(p1, p2) = l
  [p1, p2]
}

fn get_max_point(lines: List(Line)) -> Point {
  let points =
    lines
    |> list.map(line_to_points)
    |> list.flatten
  let min_x = 0
  let max_x =
    points
    |> list.map(get_x)
    |> list.reduce(int.max)
    |> result.unwrap(0)
  //
  let min_y = 0
  let max_y =
    points
    |> list.map(get_y)
    |> list.reduce(int.max)
    |> result.unwrap(0)
  //
  let range_x = list.range(min_x, max_x + 1)
  let range_y = list.range(min_y, max_y + 1)
  //
  Point(max_x + 1, max_y + 1)
  // list.fold(
  //   over: range_x,
  //   from: map.new(),
  //   with: fn(grid1, x) {
  //     list.fold(
  //       over: range_y,
  //       from: grid1,
  //       with: fn(grid2, y) {
  //         map.insert(into: grid2, for: Point(x, y), insert: 0)
  //       },
  //     )
  //   },
  // )
}

fn build_grid_hv(lines: List(Line)) -> Grid {
  let max_point = get_max_point(lines)
  let empty_grid = map.new()
  // io.debug(empty_grid)
  // grid
  list.fold(
    over: lines,
    from: empty_grid,
    with: fn(grid, line) { add_line_hv(max_point, grid, line) },
  )
}

fn grid_to_matrix(grid: Grid) {
  let points =
    grid
    |> map.keys
  let max_x =
    points
    |> list.map(get_x)
    |> list.reduce(int.max)
    |> result.unwrap(0)
  let max_y =
    points
    |> list.map(get_y)
    |> list.reduce(int.max)
    |> result.unwrap(0)
  let range_x = list.range(0, max_x + 1)
  let range_y = list.range(0, max_y + 1)
  //
  list.map(
    range_y,
    with: fn(y) {
      list.map(
        range_x,
        with: fn(x) {
          map.get(grid, Point(x, y))
          |> result.unwrap(0)
        },
      )
    },
  )
}

fn print_matrix(matrix) {
  io.debug("")
  matrix
  |> list.map(fn(row) {
    row
    |> list.map(fn(cell) {
      case cell {
        0 -> "."
        _ -> int.to_string(cell)
      }
    })
    |> string.join(" ")
    |> io.debug
  })
}

pub fn part1(file: String) {
  try input = read_input(file)

  let grid = build_grid_hv(input)
  // let matrix = grid_to_matrix(grid)
  // print_matrix(matrix)
  let with_2_or_more =
    grid
    |> map.values
    |> list.filter(fn(n) { n >= 2 })
    |> list.length

  Ok(with_2_or_more)
}
