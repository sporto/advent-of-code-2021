import gleeunit
import gleeunit/should
import gleam/result
import gleam/pair
import day17.{Probe}
import binary

const origin = #(0, 0)

pub fn resolve_test() {
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

pub fn try_trajectory_test() {
  let probe1 = Probe(origin, x_vel: 7, y_vel: 2)

  day17.try_trajectory(probe1, day17.target_test)
  |> should.equal(Ok(#(28, -7)))

  let probe2 = Probe(origin, x_vel: 9, y_vel: 0)

  day17.try_trajectory(probe2, day17.target_test)
  |> should.equal(Ok(#(30, -6)))

  let probe3 = Probe(origin, x_vel: 17, y_vel: -4)

  day17.try_trajectory(probe3, day17.target_test)
  |> should.equal(Error("Too far"))
}
