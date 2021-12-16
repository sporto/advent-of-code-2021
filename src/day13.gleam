import gleam/int
import gleam/io
import gleam/list
import gleam/result
import gleam/string
import gleam/map
import utils

type Point {
  Point(x: Int, y: Int)
}

fn get_x(point: Point) {
  point.x
}

fn get_y(point: Point) {
  point.y
}

fn read_input(file: String) {
  try content =
    utils.read_file(file)
    |> result.replace_error("Couldn't read file")
  try #(matrix_block, instructions_block) =
    string.split_once(content, "\n\n")
    |> result.replace_error("Couldn't split")
  try matrix = read_matrix_lines(matrix_block)
  try instructions = read_instructions(instructions_block)
  Ok(#(matrix, instructions))
}

fn read_matrix_lines(input: String) {
  input
  |> utils.split_lines
  |> list.map(parse_matrix_line)
  |> result.all
}

fn parse_matrix_line(line: String) {
  try #(xs, ys) =
    string.split_once(line, ",")
    |> result.replace_error("Couldn't split")

  try x =
    int.parse(xs)
    |> result.replace_error("Couldn't parse")

  try y =
    int.parse(ys)
    |> result.replace_error("Couldn't parse")

  let point = Point(x, y)
  Ok(point)
}

fn read_instructions(lines: String) {
  lines
  |> utils.split_lines
  |> list.map(read_instruction)
  |> result.all
}

fn read_instruction(line: String) {
  try #(left, right) =
    string.split_once(line, "=")
    |> result.replace_error("Couldn't split")

  let direction =
    left
    |> string.replace("fold along ", "")

  try amount =
    int.parse(right)
    |> result.replace_error("Couldn't parse")

  let ins = #(direction, amount)
  Ok(ins)
}

fn part1(input) {
  try #(matrix, instructions) = read_input(input)

  // print_matrix(matrix)
  let folded = follow(list.take(instructions, 1), matrix)

  // |> print_matrix
  let count = list.length(folded)
  Ok(count)
}

fn follow(instructions, matrix) {
  case instructions {
    [] -> matrix
    [ins, ..rest] -> {
      let next_matrix = follow_instruction(ins, matrix)
      follow(rest, next_matrix)
    }
  }
}

fn follow_instruction(ins, matrix) {
  let #(dir, amount) = ins
  case dir {
    "x" -> fold_left(matrix, amount)
    "y" -> fold_up(matrix, amount)
    _ -> matrix
  }
}

fn fold_left(matrix, where: Int) {
  fold_matrix(matrix, where, point_left)
}

fn fold_up(matrix, where: Int) {
  fold_matrix(matrix, where, point_up)
}

fn fold_matrix(matrix, where, point_positioner) {
  list.fold(
    matrix,
    list.new(),
    fn(acc, point: Point) {
      let next_point = point_positioner(point, where)
      [next_point, ..acc]
    },
  )
  |> list.unique
}

fn point_left(point, where) {
  let diff = point.x - where
  case diff > 0 {
    True -> Point(where - diff, point.y)
    False -> point
  }
}

fn point_up(point, where) {
  let diff = point.y - where
  case diff > 0 {
    True -> Point(point.x, where - diff)
    False -> point
  }
}

fn print_matrix(matrix) {
  let xx =
    matrix
    |> list.map(get_x)
  let yy =
    matrix
    |> list.map(get_y)

  let xmax = utils.list_max(xx, 0)
  let ymax = utils.list_max(yy, 0)

  let xrange = list.range(0, xmax + 1)
  let yrange = list.range(0, ymax + 1)

  list.map(
    yrange,
    fn(y) {
      list.map(
        xrange,
        fn(x) {
          let point = Point(x, y)
          case list.contains(matrix, point) {
            True -> "#"
            False -> "."
          }
        },
      )
      |> string.join("")
      |> io.println
    },
  )

  matrix
}

pub fn part1_test1() {
  part1("./data/13/test1.txt")
}

pub fn part1_main() {
  part1("./data/13/input.txt")
}
