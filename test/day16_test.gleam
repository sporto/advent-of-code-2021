import gleeunit
import gleeunit/should
import gleam/bit_string
import day16

pub fn bit_string_test() {
  [<<1, 2>>, <<3>>, <<4>>]
  |> bit_string.concat
  |> should.equal(<<1, 2, 3, 4>>)
}

pub fn convert_to_binary_test() {
  day16.hex_to_binary("D")
  |> should.equal(Ok(<<13:4>>))
  // day16.hex_to_binary("2")
  // |> should.equal(Ok(<<2:4>>))
  // day16.hex_to_binary("D2")
  // |> should.equal(Ok(0b11010010))
  // day16.hex_to_binary("D2FE28")
  // |> should.equal(Ok(<<110100101111111000101000>>))
}
