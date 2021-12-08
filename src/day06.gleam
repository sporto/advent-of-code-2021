import gleam/list

fn loop_fish(fish) {
  case fish {
    0 -> [6, 8]
    _ -> [fish - 1]
  }
}

fn loop(day: Int, fishes: List(Int)) {
  case day {
    0 -> fishes
    _ -> {
      let next =
        fishes
        |> list.map(loop_fish)
        |> list.flatten
      loop(day - 1, next)
    }
  }
}

pub fn part1(input) {
  loop(80, input)
  |> list.length
}
