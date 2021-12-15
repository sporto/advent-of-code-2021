import gleam/io
import gleam/list
import gleam/int
import gleam/result
import gleam/string
import gleam/pair
import gleam/map
import utils
import matrix

fn parse_line(line: String) {
  line
  |> string.to_graphemes
  |> list.map(int.parse)
  |> result.all
  |> result.replace_error("Couldn't parse line")
}

fn read_input(file: String) {
  utils.get_input_lines(file, parse_line)
}

pub fn part1(input) {
  try input = read_input(input)

  let grid = matrix.to_map(input)

  let total = part1_steps(100, 0, grid)

  Ok(total)
}

fn part1_steps(steps_to_go, flash_count, grid) {
  case steps_to_go {
    0 -> flash_count
    _ -> {
      let #(next, count) = step(grid)
      // io.debug(count)
      part1_steps(steps_to_go - 1, flash_count + count, next)
    }
  }
}

pub fn step(population) {
  // Increase level of each by 1
  let increased =
    population
    |> map.map_values(fn(p, level) { level + 1 })

  let flashed_pop = part1_flash(increased)

  let is_flashed = fn(p, level) { level < 0 }

  let flashed_count =
    flashed_pop
    |> map.filter(is_flashed)
    |> map.size

  // Changed flashed to 0
  let next =
    flashed_pop
    |> map.map_values(fn(p, level) {
      case level < 0 {
        True -> 0
        False -> level
      }
    })

  #(next, flashed_count)
}

pub fn part1_flash(population) {
  let to_flash =
    population
    |> map.to_list
    |> list.find(fn(t) {
      let #(p, level) = t
      level > 9
    })

  case to_flash {
    Ok(t) -> {
      let #(point, level) = t
      // Add 1 to surrounding
      // Add 1 to this one
      let surrounding = surrounding_points(point)
      let next =
        list.fold(
          surrounding,
          population,
          fn(pop, point) {
            case map.get(pop, point) {
              Ok(value) -> map.insert(pop, point, value + 1)
              Error(_) -> pop
            }
          },
        )
        |> map.insert(point, -1000)
      part1_flash(next)
    }
    Error(Nil) -> population
  }
}

fn surrounding_points(point) {
  let #(x, y) = point
  [
    #(x, y - 1),
    #(x + 1, y - 1),
    #(x + 1, y),
    #(x + 1, y + 1),
    #(x, y + 1),
    #(x - 1, y + 1),
    #(x - 1, y),
    #(x - 1, y - 1),
  ]
}

pub fn part2(input) {
  try input = read_input(input)

  let grid = matrix.to_map(input)

  let step = part2_steps(1, grid)

  Ok(step)
}

fn part2_steps(current_step, grid) {
  // keep running until all flash
  let #(next, count) = step(grid)
  case count == map.size(grid) {
    True -> current_step
    False -> part2_steps(current_step + 1, next)
  }
}

fn print_grid(grid) {
  let points = map.keys(grid)

  let xs =
    list.map(points, pair.first)
    |> list.unique

  let ys =
    list.map(points, pair.second)
    |> list.unique

  list.map(
    ys,
    fn(y) {
      list.map(
        xs,
        fn(x) {
          map.get(grid, #(x, y))
          |> result.map(int.to_string)
          |> result.unwrap(" ")
        },
      )
      |> string.join("")
      |> io.println
    },
  )
  io.println("")
  grid
}

pub fn part1_mini() {
  part1("./data/11/mini.txt")
}

pub fn part1_test() {
  part1("./data/11/test.txt")
}

pub fn part1_main() {
  part1("./data/11/input.txt")
}

pub fn part2_test() {
  part2("./data/11/test.txt")
}

pub fn part2_main() {
  part2("./data/11/input.txt")
}
