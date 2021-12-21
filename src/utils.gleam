import gleam/list
import gleam/dynamic.{Dynamic}
import gleam/string
import gleam/option.{None, Some}
import gleam/int
import gleam/result
import gleam/map.{Map}
import gleam/bool
import gleam/set.{Set}

pub external fn read_file(name: String) -> Result(String, Dynamic) =
  "file" "read_file"

pub external fn rem(Int, Int) -> Int =
  "erlang" "rem"

pub fn split_lines(file: String) -> List(String) {
  string.split(file, "\n")
}

pub fn get_input_lines(
  file_name: String,
  parse_line: fn(String) -> Result(a, String),
) -> Result(List(a), String) {
  case read_file(file_name) {
    Error(_) -> Error("Could not read file")
    Ok(file) ->
      file
      |> split_lines
      |> list.map(parse_line)
      |> result.all
  }
}

///
pub fn abs(num) {
  case num >= 0 {
    True -> num
    False -> num * -1
  }
}

pub fn fold_ranges(
  xs xs: List(Int),
  ys ys: List(Int),
  from from: acc,
  with with: fn(acc, #(Int, Int)) -> acc,
) -> acc {
  list.fold(
    over: xs,
    from: from,
    with: fn(from1, x) {
      list.fold(
        over: ys,
        from: from1,
        with: fn(from2, y) { with(from2, #(x, y)) },
      )
    },
  )
}

pub fn count(l: List(a)) -> Map(a, Int) {
  list.fold(
    over: l,
    from: map.new(),
    with: fn(acc, a) {
      map.update(
        acc,
        a,
        with: fn(op) {
          case op {
            None -> 1
            Some(prev) -> prev + 1
          }
        },
      )
    },
  )
}

pub fn update_map_count(the_map: Map(a, Int), key: a, by: Int) -> Map(a, Int) {
  map.update(
    the_map,
    key,
    fn(op) {
      case op {
        None -> by
        Some(count) -> count + by
      }
    },
  )
}

// LIST
pub fn list_min(list: List(Int), fallback: Int) -> Int {
  list
  |> list.reduce(int.min)
  |> result.unwrap(fallback)
}

pub fn list_max(list: List(Int), fallback: Int) -> Int {
  list
  |> list.reduce(int.max)
  |> result.unwrap(fallback)
}

// SETS
// Find the elements that are in one but not in two
pub fn set_diff(one: Set(a), two: Set(a)) -> Set(a) {
  set.fold(
    over: one,
    from: set.new(),
    with: fn(acc, member) {
      case set.contains(two, member) {
        True -> acc
        False -> set.insert(acc, member)
      }
    },
  )
}

// Is two included in one
pub fn set_includes(one: Set(a), two: Set(a)) -> Bool {
  set.intersection(one, two) == two
}
