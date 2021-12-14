import gleam/io
import gleam/list
import gleam/result
import gleam/string
import gleam/int
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
  AngleOpen
  // <
  AngleClose
}

fn symbol_to_string(symbol) {
  case symbol {
    ParenOpen -> "("
    ParenClose -> ")"
    SquareOpen -> "["
    SquareClose -> "]"
    CurlyOpen -> "{"
    CurlyClose -> "}"
    AngleOpen -> "<"
    AngleClose -> ">"
  }
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
    "<" -> Ok(AngleOpen)
    ">" -> Ok(AngleClose)
    _ -> Error("Invalid char")
  }
}

fn parse_line(line: String) {
  line
  |> string.to_graphemes
  |> list.map(parse_char)
  |> result.all
}

fn read_input(file: String) {
  utils.get_input_lines(file, parse_line)
}

pub fn part1(input) {
  try input = read_input(input)

  let results =
    input
    |> list.map(process_line)

  // Collect and add the errors
  let total =
    results
    |> list.map(fn(result) {
      case result {
        Ok(_) -> 0
        Error(n) -> n
      }
    })
    |> int.sum

  Ok(total)
}

fn line_to_string(symbols) {
  symbols
  |> list.map(symbol_to_string)
  |> string.join("")
}

fn process_line(symbols: List(Symbol)) -> Result(Queue(Symbol), Int) {
  io.println("  ")
  io.debug(
    symbols
    |> line_to_string,
  )

  list.try_fold(
    symbols,
    queue.new(),
    fn(stack, symbol) {
      case symbol {
        ParenOpen -> Ok(push(stack, symbol))
        ParenClose -> pop_expecting(stack, symbol, ParenOpen)
        SquareOpen -> Ok(push(stack, symbol))
        SquareClose -> pop_expecting(stack, symbol, SquareOpen)
        CurlyOpen -> Ok(push(stack, symbol))
        CurlyClose -> pop_expecting(stack, symbol, CurlyOpen)
        AngleOpen -> Ok(push(stack, symbol))
        AngleClose -> pop_expecting(stack, symbol, AngleOpen)
      }
    },
  )
  |> io.debug
}

fn pop_expecting(
  stack: Stack,
  found_symbol: Symbol,
  expected_symbol: Symbol,
) -> Result(Queue(Symbol), Int) {
  try popped =
    pop(stack)
    |> result.replace_error(0)

  let #(popped_symbol, next_stack) = popped

  case popped_symbol == expected_symbol {
    True -> Ok(next_stack)
    False ->
      case found_symbol {
        ParenClose -> Error(3)
        SquareClose -> Error(57)
        CurlyClose -> Error(1197)
        AngleClose -> Error(25137)
        _ -> Error(-1)
      }
  }
}

fn push(stack: Stack, ele: Symbol) {
  queue.push_front(stack, ele)
}

fn pop(stack: Stack) {
  queue.pop_front(stack)
}

pub fn part1_test() {
  part1("./data/10/test.txt")
}

pub fn part1_main() {
  part1("./data/10/input.txt")
}
