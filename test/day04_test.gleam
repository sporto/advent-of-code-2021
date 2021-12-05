import day04

pub fn part1_test() {
  assert Ok(4512) = day04.part1("./data/04/test.txt")
}

pub fn part1b_test() {
  assert Ok(69579) = day04.part1("./data/04/input.txt")
}

pub fn part2_test() {
  assert Ok(1924) = day04.part2("./data/04/test.txt")
}

pub fn part2b_test() {
  assert Ok(1) = day04.part2("./data/04/input.txt")
}
