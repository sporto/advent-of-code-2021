import binary.{Bin}
import gleam/bit_string
import gleam/io
import gleam/list
import gleam/pair
import gleam/result
import gleam/string

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
  Packet(version: Int, payload: PacketPayload)
}

pub type PacketPayload {
  DecimalValue(Int)
  Operator
}

pub fn parse_packet(hex: String) -> Result(#(Packet, List(Bool)), String) {
  try bin =
    hex_to_binary(hex)
    |> result.replace_error("Couldn't parse hex")

  read_packet(bin)
}

// Return the packet and unused bin
pub fn read_packet(bin: List(Bool)) -> Result(#(Packet, List(Bool)), String) {
  case bin {
    [v1, v2, v3, t1, t2, t3, ..rest] -> {
      let version = binary.binary_to_int([v1, v2, v3])
      let type_id = binary.binary_to_int([t1, t2, t3])
      try #(payload, unused) = read_packet_payload(type_id, rest)
      Ok(#(Packet(version: version, payload: payload), unused))
    }
    _ -> Error("Invalid Packet")
  }
}

pub fn read_packet_payload(type_id, bin) {
  case type_id == 4 {
    True -> {
      let #(decimal, unused) = get_decimal(bin)
      Ok(#(DecimalValue(decimal), unused))
    }
    False -> {
      try #(operator, unused) = get_operator(bin)
      Ok(#(Operator, unused))
    }
  }
}

fn get_decimal(bin: Bin) -> #(Int, Bin) {
  get_decimal_([], list.sized_chunk(bin, 5))
  |> pair.map_first(binary.binary_to_int)
}

fn get_decimal_(acc: Bin, chunks: List(Bin)) -> #(Bin, Bin) {
  case chunks {
    [] -> #(acc, [])
    [chunk, ..rest_chunks] ->
      case chunk {
        [a, b, c, d, e] -> {
          let n = [b, c, d, e]
          let next_acc = list.append(acc, n)
          case a {
            True ->
              // Keep going
              get_decimal_(next_acc, rest_chunks)
            False -> // Last chunk
            #(next_acc, list.flatten(rest_chunks))
          }
        }
        _ -> #(acc, list.flatten(chunks))
      }
  }
}

fn get_operator(bin: List(Bool)) -> Result(#(Int, Bin), String) {
  case bin {
    [id, ..rest] ->
      case id {
        False -> {
          // If the length type ID is 0, then the next 15 bits are a number that represents the total length in bits of the sub-packets contained by this packet.
          let length_bits = list.take(rest, 15)
          let length = binary.binary_to_int(length_bits)
          // This part is terrible
          todo
        }
        True ->
          // If the length type ID is 1, then the next 11 bits are a number that represents the number of sub-packets immediately contained by this packet.
          todo
      }
    _ -> Error("Invalid operator")
  }
}

pub fn part1_test() {
  1
}
