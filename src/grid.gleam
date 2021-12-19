import matrix.{Matrix}
import gleam/map.{Map}
import gleam/list
import gleam/pair
import utils

pub type Point =
  #(Int, Int)

pub type Grid(a) =
  Map(Point, a)

pub fn from_matrix(matrix: Matrix(a)) -> Grid(a) {
  list.index_map(
    matrix,
    fn(y, row) { list.index_map(row, fn(x, cell) { #(#(x, y), cell) }) },
  )
  |> list.flatten
  |> map.from_list
}

fn all_surrounding_points(point: Point) -> List(Point) {
  let #(x, y) = point
  [
    #(x, y - 1),
    #(x + 1, y - 1),
    #(x + 1, y),
    #(x + 1, y + 1),
    #(x, y + 1),
    #(x - 1, y + 1),
    #(x - 1, y),
    #(x - 1, y - 1),
  ]
}

fn straight_surrounding_points(point: Point) -> List(Point) {
  let #(x, y) = point
  [#(x - 1, y), #(x, y + 1), #(x + 1, y), #(x, y - 1)]
}

pub fn straight_points_around(grid: Grid(a), point: Point) -> List(#(Point, a)) {
  straight_surrounding_points(point)
  |> list.filter_map(fn(p: Point) {
    case map.get(grid, p) {
      Ok(el) -> Ok(#(p, el))
      Error(_) -> Error(Nil)
    }
  })
}

pub fn get_max_x(grid: Grid(a)) {
  grid
  |> map.keys
  |> list.map(pair.first)
  |> utils.list_max(0)
}

pub fn get_max_y(grid: Grid(a)) {
  grid
  |> map.keys
  |> list.map(pair.second)
  |> utils.list_max(0)
}

pub fn get_bottom_right(grid: Grid(a)) -> Point {
  let x = get_max_x(grid)
  let y = get_max_y(grid)
  #(x, y)
}
