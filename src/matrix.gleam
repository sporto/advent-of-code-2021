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

pub fn to_map(matrix: Matrix(a)) -> Map(#(Int, Int), a) {
  list.index_map(
    matrix,
    fn(y, row) { list.index_map(row, fn(x, cell) { #(#(x, y), cell) }) },
  )
  |> list.flatten
  |> map.from_list
}
