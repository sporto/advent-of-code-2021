import gleeunit
import gleeunit/should
import gleam/list
import day05.{Line, Point}

pub fn points_in_line_test() {
  day05.points_in_line(#(Point(1, 1), Point(1, 3)))
  |> list.length
  |> should.equal(3)

  day05.points_in_line(#(Point(1, 1), Point(3, 1)))
  |> list.length
  |> should.equal(3)

  day05.points_in_line(#(Point(1, 1), Point(2, 2)))
  |> list.length
  |> should.equal(2)
}

pub fn part1_test() {
  assert Ok(5) = day05.part1("./data/05/test.txt")
}

pub fn part1b_test() {
  assert Ok(7468) = day05.part1("./data/05/input.txt")
}

pub fn part2_test() {
  assert Ok(12) = day05.part2("./data/05/test.txt")
}

pub fn part2b_test() {
  assert Ok(22364) = day05.part2("./data/05/input.txt")
}
