import gleam/list
import gleam/dynamic.{Dynamic}
import gleam/string
import gleam/int
import gleam/result
import gleam/map
import gleam/bool

pub external fn read_file(name: String) -> Result(String, Dynamic) =
  "file" "read_file"

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
