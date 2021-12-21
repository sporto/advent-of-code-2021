import gleam/list
import gleam/result
import gleam/string
import gleam/io
import gleam/bit_string

fn parse_hex_char(c: String) -> Result(BitString, Nil) {
  case c {
    "0" -> Ok(<<0:4>>)
    "1" -> Ok(<<1:4>>)
    "2" -> Ok(<<2:4>>)
    "3" -> Ok(<<3:4>>)
    "4" -> Ok(<<4:4>>)
    "5" -> Ok(<<5:4>>)
    "6" -> Ok(<<6:4>>)
    "7" -> Ok(<<7:4>>)
    "8" -> Ok(<<8:4>>)
    "9" -> Ok(<<9:4>>)
    "A" -> Ok(<<10:4>>)
    "B" -> Ok(<<11:4>>)
    "C" -> Ok(<<12:4>>)
    "D" -> Ok(<<13:4>>)
    "E" -> Ok(<<14:4>>)
    "F" -> Ok(<<15:4>>)
    _ -> Error(Nil)
  }
}

pub fn hex_to_binary(hex: String) -> Result(BitString, Nil) {
  hex
  |> string.to_graphemes
  |> list.map(parse_hex_char)
  |> result.all
  // |> result.then(list.first)
  // |> io.debug
  |> result.map(bit_string.concat)
}

pub fn part1_test() {
  1
}
