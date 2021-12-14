import gleam/io
import gleam/list
import gleam/result
import gleam/string
import gleam/queue.{Queue}
import utils

type Symbol {
  ParenOpen
  ParenClose
  SquareOpen
  // [
  SquareClose
  // ]
  CurlyOpen
  // {
  CurlyClose
  // }
  PointyOpen
  // <
  PointyClose
}

type Stack =
  Queue(Symbol)

// >
fn parse_char(c: String) -> Result(Symbol, String) {
  case c {
    "(" -> Ok(ParenOpen)
    ")" -> Ok(ParenClose)
    "[" -> Ok(SquareOpen)
    "]" -> Ok(SquareClose)
    "{" -> Ok(CurlyOpen)
    "}" -> Ok(CurlyClose)
    "<" -> Ok(PointyOpen)
    ">" -> Ok(PointyClose)
    _ -> Error("Invalid char")
  }
}

fn parse_line(line: String) {
  line
  |> string.to_graphemes
  |> list.map(parse_char)
  |> result.all
}

// STACK
fn read_input(file: String) {
  utils.get_input_lines(file, parse_line)
}

pub fn part1(input) {
  try input = read_input(input)

  input
  |> list.map(run_stack)
  |> io.debug

  Ok(1)
}

fn run_stack(symbols: List(Symbol)) {
  list.try_fold(
    symbols,
    queue.new(),
    fn(stack, symbol) {
      case symbol {
        ParenOpen -> Ok(push(stack, symbol))
        ParenClose -> pop_expecting(stack, ParenOpen)
        SquareOpen -> Ok(push(stack, symbol))
        SquareClose -> pop_expecting(stack, SquareOpen)
        CurlyOpen -> Ok(push(stack, symbol))
        CurlyClose -> pop_expecting(stack, CurlyOpen)
        PointyOpen -> Ok(push(stack, symbol))
        PointyClose -> pop_expecting(stack, PointyOpen)
      }
    },
  )
}

fn pop_expecting(stack: Stack, expected_symbol: Symbol) {
  try popped =
    pop(stack)
    |> result.replace_error("Stack empty")

  let #(popposed_symbol, next_stack) = popped
  case popposed_symbol == expected_symbol {
    True -> Ok(next_stack)
    False -> Error("Unexpected symbol")
  }
}

fn push(stack: Stack, ele) {
  queue.push_front(stack, ele)
}

fn pop(stack: Stack) {
  queue.pop_front(stack)
}

pub fn part1_test() {
  part1("./data/10/test.txt")
}
