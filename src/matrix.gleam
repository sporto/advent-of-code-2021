import gleam/list
import gleam/map.{Map}

pub type Matrix(a) =
  List(List(a))

pub fn fold(
  over matrix: Matrix(a),
  from from: b,
  with: fn(Matrix(a), b) -> Matrix(c),
) -> Matrix(c) {
  // TODO
  todo
}

pub fn map(over matrix: Matrix(a), with fun: fn(a) -> b) -> Matrix(b) {
  list.map(matrix, fn(row) { list.map(row, fn(cell) { fun(cell) }) })
}
