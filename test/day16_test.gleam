import gleeunit
import gleeunit/should
import gleam/bit_string
import gleam/result
import gleam/pair
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
  |> result.map(pair.first)
  |> should.equal(Ok([
    Packet(version: 6, payload: DecimalValue(10)),
    Packet(version: 2, payload: DecimalValue(20)),
  ]))

  day16.get_operator_packets(binary.from_binary_string(
    "10000000001101010000001100100000100011000001100000",
  ))
  |> result.map(pair.first)
  |> should.equal(Ok([
    Packet(version: 2, payload: DecimalValue(1)),
    Packet(version: 4, payload: DecimalValue(2)),
    Packet(version: 1, payload: DecimalValue(3)),
  ]))
}

pub fn parse_packet_test() {
  day16.parse_packet("D2FE28")
  |> should.equal(Ok(#(
    Packet(version: 6, payload: DecimalValue(2021)),
    [False, False, False],
  )))
  day16.parse_packet("38006F45291200")
  |> result.map(pair.first)
  |> should.equal(Ok(Packet(
    version: 1,
    payload: Operator([
      Packet(version: 6, payload: DecimalValue(10)),
      Packet(version: 2, payload: DecimalValue(20)),
    ]),
  )))
  day16.parse_packet("EE00D40C823060")
  |> result.map(pair.first)
  |> should.equal(Ok(Packet(
    version: 7,
    payload: Operator([
      Packet(version: 2, payload: DecimalValue(1)),
      Packet(version: 4, payload: DecimalValue(2)),
      Packet(version: 1, payload: DecimalValue(3)),
    ]),
  )))
}

pub fn part1_test() {
  day16.part1("8A004A801A8002F478")
  |> should.equal(Ok(16))

  day16.part1("620080001611562C8802118E34")
  |> should.equal(Ok(12))

  day16.part1("C0015000016115A2E0802F182340")
  |> should.equal(Ok(23))

  day16.part1("A0016C880162017C3686B18A3D4780")
  |> should.equal(Ok(31))
}
