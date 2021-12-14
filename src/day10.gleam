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

fn opposite_symbol(symbol) {
  case symbol {
    ParenOpen -> ParenClose
    ParenClose -> ParenOpen
    SquareOpen -> SquareClose
    SquareClose -> SquareOpen
    CurlyOpen -> CurlyClose
    CurlyClose -> CurlyOpen
    AngleOpen -> AngleClose
    AngleClose -> AngleOpen
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

pub fn part2(input) {
  try input = read_input(input)

  let incomplete_lines =
    input
    |> list.filter_map(process_line)
    |> list.map(complete_line)

  let count = list.length(incomplete_lines)

  let score =
    incomplete_lines
    |> list.map(part2_line_score)
    |> list.sort(int.compare)
    |> list.drop(count / 2)
    |> list.first
    |> result.replace_error("Couldn't find the middle")
}

fn part2_line_score(line: List(Symbol)) {
  list.fold(
    line,
    0,
    fn(score, sym) {
      let sym_score = case sym {
        ParenClose -> 1
        SquareClose -> 2
        CurlyClose -> 3
        AngleClose -> 4
        _ -> 0
      }
      score * 5 + sym_score
    },
  )
}

fn line_to_string(symbols: List(Symbol)) -> String {
  symbols
  |> list.map(symbol_to_string)
  |> string.join("")
}

fn process_line(symbols: List(Symbol)) -> Result(Queue(Symbol), Int) {
  // io.println("  ")
  // io.debug(
  //   symbols
  //   |> line_to_string,
  // )
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

fn complete_line(line: Stack) -> List(Symbol) {
  queue.to_list(line)
  |> list.map(opposite_symbol)
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

pub fn part2_test() {
  part2("./data/10/test.txt")
}

pub fn part2_main() {
  part2("./data/10/input.txt")
}
