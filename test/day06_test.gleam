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
