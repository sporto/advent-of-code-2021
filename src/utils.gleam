import gleam/list
import gleam/dynamic.{Dynamic}
import gleam/string
import gleam/int
import gleam/result
import gleam/map
import gleam/bool

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
  try file =
    read_file(file_name)
    |> result.replace_error("Could not read file")

  file
  |> split_lines
  |> list.map(parse_line)
  |> result.all
}

///
pub fn abs(num) {
  case num >= 0 {
    True -> num
    False -> num * -1
  }
}

fn to_binary_(num: Int, acc: List(Bool)) -> List(Bool) {
  case num == 0 {
    True -> acc
    False -> {
      let quotient = num / 2
      let remainder = rem(num, 2)
      let bit = case remainder {
        0 -> False
        _ -> True
      }
      to_binary_(quotient, list.append([bit], acc))
    }
  }
}

pub fn to_binary(num: Int) -> List(Bool) {
  to_binary_(num, [])
}

pub fn to_binary_string(num: Int) -> String {
  to_binary(num)
  |> list.map(fn(v) {
    case v {
      True -> "1"
      False -> "0"
    }
  })
  |> string.join("")
}

fn from_binary_(total: Int, bin: List(Bool)) -> Int {
  case bin {
    [] -> total
    [first, ..rest] -> from_binary_(total * 2 + bool.to_int(first), rest)
  }
}

pub fn from_binary(bin: List(Bool)) -> Int {
  from_binary_(0, bin)
}

pub fn from_binary_string(bin: String) -> Int {
  bin
  |> string.to_graphemes
  |> list.filter_map(int.parse)
  |> list.filter_map(fn(n) {
    case n {
      0 -> Ok(False)
      1 -> Ok(True)
      _ -> Error(Nil)
    }
  })
  |> from_binary
}
