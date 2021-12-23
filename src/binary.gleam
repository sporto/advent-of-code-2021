import gleam/bool
import gleam/string
import gleam/list
import gleam/int
import utils

pub type Bin =
  List(Bool)

fn to_binary_(num: Int, acc: Bin) -> Bin {
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

pub fn to_binary(num: Int) -> Bin {
  to_binary_(num, [])
}

pub fn to_binary_sized(num: Int, size: Int) -> Bin {
  num
  |> to_binary
  |> sized(size)
}

pub fn int_to_binary_string(num: Int) -> String {
  to_binary(num)
  |> binary_to_string
}

pub fn binary_to_string(bin: Bin) -> String {
  bin
  |> list.map(fn(v) {
    case v {
      True -> "1"
      False -> "0"
    }
  })
  |> string.join("")
}

fn binary_to_int_(total: Int, bin: Bin) -> Int {
  case bin {
    [] -> total
    [first, ..rest] -> binary_to_int_(total * 2 + bool.to_int(first), rest)
  }
}

pub fn binary_to_int(bin: Bin) -> Int {
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

pub fn sized(bin: Bin, size: Int) -> Bin {
  bin
  |> list.reverse
  |> list.append(list.repeat(False, times: size))
  |> list.take(size)
  |> list.reverse
}

pub fn concat(lists) {
  list.flatten(lists)
}
