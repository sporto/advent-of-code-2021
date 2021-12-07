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
