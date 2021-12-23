type Target {
  Target(x_min: Int, x_max: Int, y_min: Int, y_max: Int)
}

pub type Point =
  #(Int, Int)

pub type Probe {
  Probe(location: Point, x_vel: Int, y_vel: Int)
}

fn get_location(probe: Probe) {
  probe.location
}

// target area: x=20..30, y=-10..-5
const input_test = Target(20, 30, -10, -5)

// input
// target area: x=85..145, y=-163..-108
const input_main = Target(85, 145, -163, -108)

fn is_within_target_area(point: Point, area: Target) {
  let #(x, y) = point
  x >= area.x_min && x <= area.x_max && y >= area.y_min && y <= area.y_max
}

pub fn resolve(probe: Probe, steps_to_go: Int) -> Probe {
  case steps_to_go {
    0 -> probe
    _ -> {
      let #(x, y) = probe.location
      let next_point = #(x + probe.x_vel, y + probe.y_vel)
      let next_probe =
        Probe(
          next_point,
          x_vel: one_toward_zero(probe.x_vel),
          y_vel: probe.y_vel - 1,
        )
      resolve(next_probe, steps_to_go - 1)
    }
  }
}

pub fn resolve_location(probe: Probe, steps_to_go: Int) -> Point {
  resolve(probe, steps_to_go)
  |> get_location
}

fn one_toward_zero(n) {
  case n == 0 {
    True -> 0
    False ->
      case n > 0 {
        True -> n - 1
        False -> n + 1
      }
  }
}

pub fn part1(input) {
  Ok(1)
}

pub fn part1_test() {
  part1(input_test)
}
