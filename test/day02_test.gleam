import gleeunit
import gleeunit/should
import day02

pub fn part1_test() {
  assert Ok(150) = day02.part1("./data/02/test.txt")
}

pub fn part1b_test() {
  assert Ok(1654760) = day02.part1("./data/02/input.txt")
}

pub fn part2_test() {
  assert Ok(900) = day02.part2("./data/02/test.txt")
}

pub fn part2b_test() {
  assert Ok(1956047400) = day02.part2("./data/02/input.txt")
}
