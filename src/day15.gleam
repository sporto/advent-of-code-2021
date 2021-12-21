import gleam/int
import gleam/io
import gleam/list
import gleam/result
import gleam/string
import gleam/pair
import gleam/set.{Set}
import gleam/option.{None, Option, Some}
import gleam/map.{Map}
import utils
import matrix
import grid.{Grid, Point}

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

type PointValue {
  PointValue(entry_cost: Int, total_cost: Option(Int))
}

fn get_total_cost(point_value: PointValue) -> Option(Int) {
  point_value.total_cost
}

fn get_total_cost_result(point_value: PointValue) -> Result(Int, String) {
  get_total_cost(point_value)
  |> option.to_result("No total cost")
}

pub fn part1(input) {
  try parsed_input = read_input(input)

  parsed_input
  |> grid.from_matrix
  |> run
}

pub fn part2(input) {
  try parsed_input = read_input(input)

  parsed_input
  |> grid.from_matrix
  |> expand_grid
  |> print_grid_size
  |> run
}

fn print_grid_size(g) {
  g
  |> map.size
  |> io.debug
  g
}

fn expand_grid(points_grid) {
  // increase down
  // then right
  let factors = [0, 1, 2, 3, 4]

  let width = grid.get_max_x(points_grid) + 1
  let height = grid.get_max_y(points_grid) + 1

  let wrap = fn(n) {
    case n > 9 {
      True -> n - 9
      False -> n
    }
  }

  let add_point = fn(acc, point, value, factor, down) {
    let #(x, y) = point
    let next_value =
      value + factor
      |> wrap

    let next_point = case down {
      True -> #(x, y + factor * height)
      False -> #(x + factor * width, y)
    }
    map.insert(acc, next_point, next_value)
  }

  points_grid
  // |> print_grid_size
  |> map.fold(
    map.new(),
    fn(acc, point, value) {
      list.fold(
        factors,
        acc,
        fn(acc2, factor) { add_point(acc2, point, value, factor, True) },
      )
    },
  )
  // |> print_grid_size
  |> map.fold(
    map.new(),
    fn(acc, point, value) {
      list.fold(
        factors,
        acc,
        fn(acc2, factor) { add_point(acc2, point, value, factor, False) },
      )
    },
  )
}

fn run(points_grid) {
  let unvisited =
    points_grid
    |> map.keys
    |> set.from_list

  let end_point = grid.get_bottom_right(points_grid)

  points_grid
  |> map.map_values(fn(point, entry_cost) {
    case point == #(0, 0) {
      True -> PointValue(entry_cost, Some(0))
      False -> PointValue(entry_cost, None)
    }
  })
  |> loop(unvisited, end_point)
}

fn loop(points_grid: Grid(PointValue), unvisited: Set(Point), end_point: Point) {
  // Select the unvisited node that is marked with the smallest tentative distance, set it as the new current node.
  // Find nodes unvisited and marked
  let maybe_next_node = find_next_node_to_visit(unvisited, points_grid)

  case maybe_next_node {
    Ok(next_node) -> {
      try #(next_points_grid, next_unvisited) =
        visit(next_node, points_grid, unvisited)
      loop(next_points_grid, next_unvisited, end_point)
    }
    Error(_) ->
      map.get(points_grid, end_point)
      |> result.replace_error("Could not find end point")
      |> result.then(get_total_cost_result)
  }
}

fn find_next_node_to_visit(unvisited: Set(Point), points_grid) {
  unvisited
  |> set.to_list
  |> list.filter_map(fn(point: Point) {
    get_point_total_cost(point, points_grid)
    |> result.map(fn(total_cost) { #(point, total_cost) })
  })
  |> list.sort(fn(a, b) { int.compare(pair.second(a), pair.second(b)) })
  |> list.map(pair.first)
  |> list.first
  |> result.replace_error("Could not find next node")
}

fn visit(
  current_point: Point,
  points_grid: Grid(PointValue),
  unvisited: Set(Point),
) {
  try current_point_cost = get_point_total_cost(current_point, points_grid)

  let unvisited_neighbors =
    grid.straight_points_around(points_grid, current_point)
    |> are_unvisited(unvisited)

  // Calc each tentative cost
  let next_points_grid =
    list.fold(
      unvisited_neighbors,
      points_grid,
      fn(acc_points_grid: Grid(PointValue), neighbor: #(Point, PointValue)) -> Grid(
        PointValue,
      ) {
        let #(neighbor_point, neighbor_value) = neighbor

        let calc_cost = current_point_cost + neighbor_value.entry_cost

        let smaller_cost = case neighbor_value.total_cost {
          None -> calc_cost
          Some(cost) -> int.min(cost, calc_cost)
        }

        // Assign the smallest one
        let next_value =
          PointValue(..neighbor_value, total_cost: Some(smaller_cost))

        map.insert(acc_points_grid, neighbor_point, next_value)
      },
    )

  let next_unvisited = set.delete(unvisited, current_point)

  Ok(#(next_points_grid, next_unvisited))
}

fn get_point_total_cost(
  point: Point,
  points_grid: Grid(PointValue),
) -> Result(Int, String) {
  map.get(points_grid, point)
  |> result.replace_error("Coudn't get the point")
  |> result.then(get_total_cost_result)
}

fn are_unvisited(
  points: List(#(Point, PointValue)),
  unvisited: Set(Point),
) -> List(#(Point, PointValue)) {
  list.filter(points, is_unvisited(_, unvisited))
}

fn is_unvisited(point_and_value: #(Point, PointValue), unvisited: Set(Point)) {
  set.contains(unvisited, pair.first(point_and_value))
}

pub fn part1_test() {
  part1("./data/15/test1.txt")
}

pub fn part1_main() {
  part1("./data/15/input.txt")
}

pub fn part2_test() {
  part2("./data/15/test1.txt")
}

pub fn part2_main() {
  part2("./data/15/input.txt")
}
