import gleam/io
import gleam/int
import day06

pub fn main() {
  // 26984457539
  day06.part2(day06.test_input)
  |> int.to_string
  |> io.println
}
