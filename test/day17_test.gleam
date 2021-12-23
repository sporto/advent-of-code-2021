import gleeunit
import gleeunit/should
import gleam/result
import gleam/pair
import day17.{Probe}
import binary

pub fn resolve_test() {
  let origin = #(0, 0)
  let probe1 = Probe(origin, x_vel: 7, y_vel: 2)

  day17.resolve_location(probe1, 1)
  |> should.equal(#(7, 2))

  day17.resolve_location(probe1, 2)
  |> should.equal(#(7 + 6, 2 + 1))

  day17.resolve_location(probe1, 3)
  |> should.equal(#(7 + 6 + 5, 2 + 1))

  day17.resolve_location(probe1, 4)
  |> should.equal(#(7 + 6 + 5 + 4, 2))
}
