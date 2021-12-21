import gleeunit
import gleeunit/should
import day07

pub fn part1_test() {
  day07.part1(day07.test_input)
  |> should.equal(37)
}
// pub fn part1b_test() {
//   day07.part1(day07.input)
//   |> should.equal(343468)
// }
// pub fn part2_test() {
//   day07.part2(day07.test_input)
//   |> should.equal(168)
// }
// pub fn part2b_test() {
//   day07.part2(day07.input)
//   |> should.equal(96086265)
// }
