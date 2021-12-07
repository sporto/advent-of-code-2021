import gleeunit
import gleeunit/should
import day03

pub fn part1_test() {
  assert Ok(198) = day03.part1("./data/03/test.txt")
}

pub fn part1b_test() {
  assert Ok(4147524) = day03.part1("./data/03/input.txt")
}

pub fn part2_test() {
  assert Ok(230) = day03.part2("./data/03/test.txt")
}

pub fn part2b_test() {
  assert Ok(3570354) = day03.part2("./data/03/input.txt")
}
