import gleeunit
import gleeunit/should
import gleam/bit_string
import day16.{DecimalValue, Operator, Packet, PacketPayload}
import binary

pub fn convert_to_binary_test() {
  let b2 = [False, False, True, False]
  let b13 = [True, True, False, True]

  day16.hex_to_binary("D")
  |> should.equal(Ok(b13))

  day16.hex_to_binary("D2")
  |> should.equal(Ok([True, True, False, True, False, False, True, False]))
}

pub fn read_packet_payload_test() {
  day16.read_packet(binary.from_binary_string("11010001010"))
  |> should.equal(Ok(#(Packet(version: 6, payload: DecimalValue(10)), [])))

  day16.read_packet(binary.from_binary_string("0101001000100100"))
  |> should.equal(Ok(#(Packet(version: 2, payload: DecimalValue(20)), [])))
}

pub fn get_operator_packets_test() {
  day16.get_operator_packets(binary.from_binary_string(
    "00000000000110111101000101001010010001001000000000",
  ))
  |> should.equal(Ok(#(
    [
      Packet(version: 6, payload: DecimalValue(10)),
      Packet(version: 2, payload: DecimalValue(20)),
    ],
    [],
  )))
}

pub fn parse_packet_test() {
  day16.parse_packet("D2FE28")
  |> should.equal(Ok(#(
    Packet(version: 6, payload: DecimalValue(2021)),
    [False, False, False],
  )))
  day16.parse_packet("38006F45291200")
  |> should.equal(Ok(#(
    Packet(
      version: 1,
      payload: Operator([
        Packet(version: 6, payload: DecimalValue(10)),
        Packet(version: 2, payload: DecimalValue(20)),
      ]),
    ),
    [],
  )))
}
