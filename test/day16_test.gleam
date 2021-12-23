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

const input = "620D7800996600E43184312CC01A88913E1E180310FA324649CD5B9DA6BFD107003A4FDE9C718593003A5978C00A7003C400A70025400D60259D400B3002880792201B89400E601694804F1201119400C600C144008100340013440021279A5801AE93CA84C10CF3D100875401374F67F6119CA46769D8664E76FC9E4C01597748704011E4D54D7C0179B0A96431003A48ECC015C0068670FA7EF1BC5166CE440239EFC226F228129E8C1D6633596716E7D4840129C4C8CA8017FCFB943699B794210CAC23A612012EB40151006E2D4678A4200EC548CF12E4FDE9BD4A5227C600F80021D08219C1A00043A27C558AA200F4788C91A1002C893AB24F722C129BDF5121FA8011335868F1802AE82537709999796A7176254A72F8E9B9005BD600A4FD372109FA6E42D1725EDDFB64FFBD5B8D1802323DC7E0D1600B4BCDF6649252B0974AE48D4C0159392DE0034B356D626A130E44015BD80213183A93F609A7628537EB87980292A0D800F94B66546896CCA8D440109F80233ABB3ABF3CB84026B5802C00084C168291080010C87B16227CB6E454401946802735CA144BA74CFF71ADDC080282C00546722A1391549318201233003361006A1E419866200DC758330525A0C86009CC6E7F2BA00A4E7EF7AD6E873F7BD6B741300578021B94309ABE374CF7AE7327220154C3C4BD395C7E3EB756A72AC10665C08C010D0046458E72C9B372EAB280372DFE1BCA3ECC1690046513E5D5E79C235498B9002BD132451A5C78401B99AFDFE7C9A770D8A0094EDAC65031C0178AB3D8EEF8E729F2C200D26579BEDF277400A9C8FE43D3030E010C6C9A078853A431C0C0169A5CB00400010F8C9052098002191022143D30047C011100763DC71824200D4368391CA651CC0219C51974892338D0"

pub fn part1_main_test() {
  day16.part1(input)
  |> should.equal(Ok(897))
}
