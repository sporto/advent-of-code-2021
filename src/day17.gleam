pub type Target {
  Target(x_left: Int, x_right: Int, y_top: Int, y_bottom: Int)
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
pub const target_test = Target(20, 30, -10, -5)

// input
// target area: x=85..145, y=-163..-108
const target_main = Target(85, 145, -163, -108)

fn is_within_target_area(point: Point, area: Target) {
  let #(x, y) = point
  x >= area.x_left && x <= area.x_right && y >= area.y_top && y <= area.y_bottom
}

fn is_pass_target_area(point: Point, area: Target) {
  let #(x, y) = point
  x > area.x_right || y < area.y_bottom
}

pub fn resolve(probe: Probe, steps_to_go: Int) -> Probe {
  case steps_to_go {
    0 -> probe
    _ -> {
      let next_probe = step(probe)
      resolve(next_probe, steps_to_go - 1)
    }
  }
}

pub fn resolve_location(probe: Probe, steps_to_go: Int) -> Point {
  resolve(probe, steps_to_go)
  |> get_location
}

pub fn step(probe: Probe) -> Probe {
  let #(x, y) = probe.location
  let next_point = #(x + probe.x_vel, y + probe.y_vel)

  Probe(next_point, x_vel: one_toward_zero(probe.x_vel), y_vel: probe.y_vel - 1)
}

pub fn try_trajectory(probe: Probe, area: Target) -> Result(Point, String) {
  let point = probe.location
  // step until pass the area
  case is_within_target_area(point, area) {
    True -> Ok(point)
    False ->
      case is_pass_target_area(point, area) {
        True -> Error("Too far")
        False -> try_trajectory(step(probe), area)
      }
  }
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
  part1(target_test)
}
