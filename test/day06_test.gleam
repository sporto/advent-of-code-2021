import gleeunit
import gleeunit/should
import day06

pub fn part1_test() {
  day06.part1(day06.test_input)
  |> should.equal(5934)
}

pub fn part1b_test() {
  day06.part1(day06.input)
  |> should.equal(343441)
}

pub fn part2_test() {
  day06.part2(day06.test_input)
  |> should.equal(26984457539)
}

pub fn part2b_test() {
  day06.part2(day06.input)
  |> should.equal(1569108373832)
}
