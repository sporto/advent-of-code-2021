import gleeunit
import gleeunit/should
import day01

pub fn part1_test() {
  day01.part1()
  |> should.equal(Ok(1759))
}

pub fn part2_test() {
  assert Ok(1805) = day01.part2()
}
