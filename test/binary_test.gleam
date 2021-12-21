import gleeunit
import gleeunit/should
import gleam/bit_string
import binary

pub fn to_binary_test() {
  binary.to_binary(2)
  |> should.equal([True, False])
}

pub fn int_to_binary_string_test() {
  binary.int_to_binary_string(2)
  |> should.equal("10")
}

pub fn binary_to_string() {
  binary.binary_to_string([True, False])
  |> should.equal("10")
}

pub fn binary_to_int() {
  binary.binary_to_int([True, False])
  |> should.equal(2)
}

pub fn from_binary_string_test() {
  binary.from_binary_string("10")
  |> should.equal(2)
}

pub fn sized_test() {
  binary.sized([True, False], 4)
  |> should.equal([False, False, True, False])

  binary.sized([False, False, True, False], 2)
  |> should.equal([True, False])
}
