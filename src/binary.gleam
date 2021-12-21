import gleam/bool
import gleam/string
import gleam/list
import gleam/int
import utils

fn to_binary_(num: Int, acc: List(Bool)) -> List(Bool) {
  case num == 0 {
    True -> acc
    False -> {
      let quotient = num / 2
      let remainder = utils.rem(num, 2)
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

pub fn int_to_binary_string(num: Int) -> String {
  to_binary(num)
  |> binary_to_string
}

pub fn binary_to_string(bin: List(Bool)) -> String {
  bin
  |> list.map(fn(v) {
    case v {
      True -> "1"
      False -> "0"
    }
  })
  |> string.join("")
}

fn binary_to_int_(total: Int, bin: List(Bool)) -> Int {
  case bin {
    [] -> total
    [first, ..rest] -> binary_to_int_(total * 2 + bool.to_int(first), rest)
  }
}

pub fn binary_to_int(bin: List(Bool)) -> Int {
  binary_to_int_(0, bin)
}

/// Convert a string "1101" to int
/// Invalid chars are discarded
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
  |> binary_to_int
}

pub fn sized(bin: List(Bool), size: Int) -> List(Bool) {
  bin
  |> list.reverse
  |> list.append(list.repeat(False, times: size))
  |> list.take(size)
  |> list.reverse
}
