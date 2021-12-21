import gleam/list
import gleam/result
import gleam/string
import gleam/io
import gleam/bit_string
import binary

fn parse_hex_char(c: String) -> Result(List(Bool), Nil) {
  case c {
    "0" -> Ok(binary.to_binary_sized(0, 4))
    "1" -> Ok(binary.to_binary_sized(1, 4))
    "2" -> Ok(binary.to_binary_sized(2, 4))
    "3" -> Ok(binary.to_binary_sized(3, 4))
    "4" -> Ok(binary.to_binary_sized(4, 4))
    "5" -> Ok(binary.to_binary_sized(5, 4))
    "6" -> Ok(binary.to_binary_sized(6, 4))
    "7" -> Ok(binary.to_binary_sized(7, 4))
    "8" -> Ok(binary.to_binary_sized(8, 4))
    "9" -> Ok(binary.to_binary_sized(9, 4))
    "A" -> Ok(binary.to_binary_sized(10, 4))
    "B" -> Ok(binary.to_binary_sized(11, 4))
    "C" -> Ok(binary.to_binary_sized(12, 4))
    "D" -> Ok(binary.to_binary_sized(13, 4))
    "E" -> Ok(binary.to_binary_sized(14, 4))
    "F" -> Ok(binary.to_binary_sized(15, 4))
    _ -> Error(Nil)
  }
}

pub fn hex_to_binary(hex: String) -> Result(List(Bool), Nil) {
  hex
  |> string.to_graphemes
  |> list.map(parse_hex_char)
  |> result.all
  // |> result.then(list.first)
  // |> io.debug
  |> result.map(binary.concat)
}

pub type Packet {
  Packet(version: Int, is_literal_value: Bool, decimal_value: Int)
}

pub fn parse_packet(hex: String) -> Result(Packet, String) {
  try bin =
    hex_to_binary(hex)
    |> result.replace_error("Couldn't parse hex")

  case bin {
    [v1, v2, v3, t1, t2, t3, ..rest] -> {
      let version = binary.binary_to_int([v1, v2, v3])
      let type_id = binary.binary_to_int([t1, t2, t3])
      let decimal = get_decimal(rest)
      Ok(Packet(
        version: version,
        is_literal_value: type_id == 4,
        decimal_value: decimal,
      ))
    }
    _ -> Error("Invalid Packet")
  }
}

fn get_decimal(bin: List(Bool)) {
  bin
  |> list.sized_chunk(5)
  |> list.fold_until(
    [],
    fn(acc: List(Bool), chunk) {
      case chunk {
        [a, b, c, d, e] -> {
          let n = [b, c, d, e]
          let next_acc = list.append(acc, n)
          case a == True {
            True -> list.Continue(next_acc)
            False -> list.Stop(next_acc)
          }
        }
        _ -> list.Stop(acc)
      }
    },
  )
  |> binary.binary_to_int
}

pub fn part1_test() {
  1
}
