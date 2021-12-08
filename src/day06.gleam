import gleam/list
import gleam/map.{Map}
import gleam/int
import gleam/io
import gleam/result
import gleam/option.{None, Some}

pub const test_input = [3, 4, 3, 1, 2]

pub const input = [
  3, 5, 2, 5, 4, 3, 2, 2, 3, 5, 2, 3, 2, 2, 2, 2, 3, 5, 3, 5, 5, 2, 2, 3, 4, 2, 3,
  5, 5, 3, 3, 5, 2, 4, 5, 4, 3, 5, 3, 2, 5, 4, 1, 1, 1, 5, 1, 4, 1, 4, 3, 5, 2, 3,
  2, 2, 2, 5, 2, 1, 2, 2, 2, 2, 3, 4, 5, 2, 5, 4, 1, 3, 1, 5, 5, 5, 3, 5, 3, 1, 5,
  4, 2, 5, 3, 3, 5, 5, 5, 3, 2, 2, 1, 1, 3, 2, 1, 2, 2, 4, 3, 4, 1, 3, 4, 1, 2, 2,
  4, 1, 3, 1, 4, 3, 3, 1, 2, 3, 1, 3, 4, 1, 1, 2, 5, 1, 2, 1, 2, 4, 1, 3, 2, 1, 1,
  2, 4, 3, 5, 1, 3, 2, 1, 3, 2, 3, 4, 5, 5, 4, 1, 3, 4, 1, 2, 3, 5, 2, 3, 5, 2, 1,
  1, 5, 5, 4, 4, 4, 5, 3, 3, 2, 5, 4, 4, 1, 5, 1, 5, 5, 5, 2, 2, 1, 2, 4, 5, 1, 2,
  1, 4, 5, 4, 2, 4, 3, 2, 5, 2, 2, 1, 4, 3, 5, 4, 2, 1, 1, 5, 1, 4, 5, 1, 2, 5, 5,
  1, 4, 1, 1, 4, 5, 2, 5, 3, 1, 4, 5, 2, 1, 3, 1, 3, 3, 5, 5, 1, 4, 1, 3, 2, 2, 3,
  5, 4, 3, 2, 5, 1, 1, 1, 2, 2, 5, 3, 4, 2, 1, 3, 2, 5, 3, 2, 2, 3, 5, 2, 1, 4, 5,
  4, 4, 5, 5, 3, 3, 5, 4, 5, 5, 4, 3, 5, 3, 5, 3, 1, 3, 2, 2, 1, 4, 4, 5, 2, 2, 4,
  2, 1, 4,
]

fn step_fish(fish) {
  case fish {
    0 -> [6, 8]
    _ -> [fish - 1]
  }
}

fn step_fishes(fishes) {
  case fishes {
    [] -> []
    [f, ..rest] -> list.append(step_fish(f), step_fishes(rest))
  }
}

// This is too slow
fn loop_v1(day: Int, fishes: List(Int)) {
  case day {
    0 -> fishes
    _ -> loop_v1(day - 1, step_fishes(fishes))
  }
}

fn loop_v2_day(counts: Map(Int, Int)) -> Map(Int, Int) {
  let count_in_zero =
    counts
    |> map.get(0)
    |> result.unwrap(0)
  //
  let increment = fn(op) {
    case op {
      None -> count_in_zero
      Some(v) -> v + count_in_zero
    }
  }

  // Reduce the timer for all
  map.fold(
    over: counts,
    from: map.new(),
    with: fn(acc: Map(Int, Int), timer, count) {
      map.insert(acc, timer - 1, count)
    },
  )
  // Remove -1
  |> map.delete(-1)
  // Everyone in -1 goes to 6
  |> map.update(6, increment)
  // For everyone in -1 create a new 8
  |> map.update(8, increment)
}

fn loop_v2(day: Int, counts: Map(Int, Int)) -> Map(Int, Int) {
  case day {
    0 -> counts
    _ -> loop_v2(day - 1, loop_v2_day(counts))
  }
}

fn make_count_map(input: List(Int)) -> Map(Int, Int) {
  let add = fn(acc, i) {
    map.update(
      acc,
      update: i,
      with: fn(op) {
        case op {
          None -> 1
          Some(cur) -> cur + 1
        }
      },
    )
  }
  list.fold(over: input, from: map.new(), with: add)
}

pub fn part1(input) {
  // loop(80, input)
  // |> list.length
  let counts = make_count_map(input)
  // io.debug(counts)
  loop_v2(80, counts)
  |> count_total
}

fn count_total(counts: Map(Int, Int)) -> Int {
  counts
  |> map.values
  |> int.sum
}

pub fn part2(input) {
  let counts = make_count_map(input)
  // io.debug(counts)
  loop_v2(256, counts)
  |> count_total
}
