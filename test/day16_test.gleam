import gleeunit
import gleeunit/should
import gleam/bit_string
import day16
import binary

pub fn convert_to_binary_test() {
  let b2 = [False, False, True, False]
  let b13 = [True, True, False, True]

  day16.hex_to_binary("D")
  |> should.equal(Ok(b13))

  day16.hex_to_binary("D2")
  |> should.equal(Ok([True, True, False, True, False, False, True, False]))
}
