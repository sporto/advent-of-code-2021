import gleeunit
import gleeunit/should
import day05

pub fn part1_testx() {
  assert Ok(5) = day05.part1("./data/05/test.txt")
}

pub fn part1b_testx() {
  assert Ok(7468) = day05.part1("./data/05/input.txt")
}

pub fn part2_testx() {
  assert Ok(12) = day05.part2("./data/05/test.txt")
}

pub fn part2b_test() {
  assert Ok(12) = day05.part2("./data/05/input.txt")
}
