///|
enum LogicToken {
  Ident(String)
  True
  False
  Not
  And
  Or
  Xor
  LParen
  RParen
  Comma
  Eof
} derive(Eq)

///|
fn is_logic_function_id(function_id : String) -> Bool {
  match function_id {
    "logic_simplify" | "logic_to_cnf" | "logic_to_dnf" | "logic_satisfiable" =>
      true
    _ => false
  }
}

///|
fn logic_expr_text(expr : @symlogic.BoolExpr) -> String {
  @symlogic.to_string(expr)
}

///|
fn logic_expr_structural_form(expr : @symlogic.BoolExpr) -> String {
  match expr {
    @symlogic.BoolExpr::True => "True"
    @symlogic.BoolExpr::False => "False"
    @symlogic.BoolExpr::Symbol(name) => "Symbol(\{name})"
    @symlogic.BoolExpr::LRA(constraint) => "LRA(\{constraint})"
    @symlogic.BoolExpr::Not(inner) =>
      "Not(\{logic_expr_structural_form(inner)})"
    @symlogic.BoolExpr::And(args) =>
      "And([" +
      args.map(logic_expr_structural_form).join(", ") +
      "])"
    @symlogic.BoolExpr::Or(args) =>
      "Or([" +
      args.map(logic_expr_structural_form).join(", ") +
      "])"
    @symlogic.BoolExpr::Xor(args) =>
      "Xor([" +
      args.map(logic_expr_structural_form).join(", ") +
      "])"
    @symlogic.BoolExpr::Implies(lhs, rhs) =>
      "Implies(\{logic_expr_structural_form(lhs)}, \{logic_expr_structural_form(rhs)})"
    @symlogic.BoolExpr::Equivalent(args) =>
      "Equivalent([" +
      args.map(logic_expr_structural_form).join(", ") +
      "])"
    @symlogic.BoolExpr::ITE(c, t, e) =>
      "ITE(\{logic_expr_structural_form(c)}, \{logic_expr_structural_form(t)}, \{logic_expr_structural_form(e)})"
  }
}

///|
fn logic_char_at(src : String, index : Int) -> Char? {
  src.get_char(index)
}

///|
fn logic_is_ident_start(ch : Char) -> Bool {
  ch == '_' || ch.is_ascii_alphabetic()
}

///|
fn logic_is_ident_continue(ch : Char) -> Bool {
  logic_is_ident_start(ch) || ch.is_ascii_digit()
}

///|
fn logic_scan_ident(src : String, start : Int) -> (LogicToken, Int) {
  let mut index = start
  while (match logic_char_at(src, index) {
          Some(ch) => logic_is_ident_continue(ch)
          None => false
        }) {
    index += 1
  }
  let name = src.unsafe_substring(start~, end=index)
  let token = match name {
    "True" => LogicToken::True
    "False" => LogicToken::False
    _ => LogicToken::Ident(name)
  }
  (token, index)
}

///|
fn logic_lex(src : String) -> Result[Array[LogicToken], String] {
  let tokens : Array[LogicToken] = []
  let mut index = 0
  while index < src.length() {
    let ch = match logic_char_at(src, index) {
      Some(ch) => ch
      None => break
    }
    if ch.is_ascii_whitespace() {
      index += ch.utf16_len()
      continue
    }
    let (token, next) = match ch {
      '~' => (LogicToken::Not, index + 1)
      '&' => (LogicToken::And, index + 1)
      '|' => (LogicToken::Or, index + 1)
      '^' => (LogicToken::Xor, index + 1)
      '(' => (LogicToken::LParen, index + 1)
      ')' => (LogicToken::RParen, index + 1)
      ',' => (LogicToken::Comma, index + 1)
      _ if logic_is_ident_start(ch) => logic_scan_ident(src, index)
      _ => return Err("Unsupported logic character '\{ch}'. Use symbols, ~, &, |, ^, commas, and parentheses.")
    }
    tokens.push(token)
    index = next
  }
  tokens.push(LogicToken::Eof)
  Ok(tokens)
}

///|
fn logic_parse_call(
  name : String,
  tokens : Array[LogicToken],
  start : Int,
) -> Result[(@symlogic.BoolExpr, Int), String] {
  let args : Array[@symlogic.BoolExpr] = []
  let mut index = start
  while tokens[index] != LogicToken::RParen {
    let parsed = logic_parse_or(tokens, index)
    match parsed {
      Err(message) => return Err(message)
      Ok((arg, next)) => {
        args.push(arg)
        index = next
      }
    }
    if tokens[index] == LogicToken::Comma {
      index += 1
    } else if tokens[index] != LogicToken::RParen {
      return Err("Expected ',' or ')' in logic function call.")
    }
  }
  let result = match name {
    "And" => Ok(@symlogic.bool_and(args))
    "Or" => Ok(@symlogic.bool_or(args))
    "Xor" => Ok(@symlogic.bool_xor(args))
    "Not" =>
      match args {
        [arg] => Ok(@symlogic.bool_not(arg))
        _ => Err("Not(...) expects exactly 1 argument.")
      }
    "Implies" =>
      match args {
        [lhs, rhs] => Ok(@symlogic.bool_implies(lhs, rhs))
        _ => Err("Implies(...) expects exactly 2 arguments.")
      }
    "Equivalent" =>
      if args.length() >= 2 {
        Ok(@symlogic.bool_equivalent(args))
      } else {
        Err("Equivalent(...) expects at least 2 arguments.")
      }
    _ => Err("Unsupported logic callable '\{name}'.")
  }
  match result {
    Err(message) => Err(message)
    Ok(expr) => Ok((expr, index + 1))
  }
}

///|
fn logic_parse_primary(
  tokens : Array[LogicToken],
  start : Int,
) -> Result[(@symlogic.BoolExpr, Int), String] {
  match tokens[start] {
    LogicToken::True => Ok((@symlogic.bool_true(), start + 1))
    LogicToken::False => Ok((@symlogic.bool_false(), start + 1))
    LogicToken::Ident(name) =>
      match tokens[start + 1] {
        LogicToken::LParen => logic_parse_call(name, tokens, start + 2)
        _ => Ok((@symlogic.bool_symbol(name), start + 1))
      }
    LogicToken::LParen => {
      let parsed = logic_parse_or(tokens, start + 1)
      match parsed {
        Err(message) => Err(message)
        Ok((expr, next)) =>
          match tokens[next] {
            LogicToken::RParen => Ok((expr, next + 1))
            _ => Err("Expected ')' to close grouped logic expression.")
          }
      }
    }
    _ => Err("Expected a logic symbol, constant, or parenthesized formula.")
  }
}

///|
fn logic_parse_unary(
  tokens : Array[LogicToken],
  start : Int,
) -> Result[(@symlogic.BoolExpr, Int), String] {
  match tokens[start] {
    LogicToken::Not =>
      match logic_parse_unary(tokens, start + 1) {
        Err(message) => Err(message)
        Ok((inner, next)) => Ok((@symlogic.bool_not(inner), next))
      }
    _ => logic_parse_primary(tokens, start)
  }
}

///|
fn logic_parse_and(
  tokens : Array[LogicToken],
  start : Int,
) -> Result[(@symlogic.BoolExpr, Int), String] {
  let parsed = logic_parse_unary(tokens, start)
  match parsed {
    Err(message) => Err(message)
    Ok((first, next)) => {
      let args : Array[@symlogic.BoolExpr] = [first]
      let mut index = next
      while tokens[index] == LogicToken::And {
        let rhs = logic_parse_unary(tokens, index + 1)
        match rhs {
          Err(message) => return Err(message)
          Ok((expr, next_rhs)) => {
            args.push(expr)
            index = next_rhs
          }
        }
      }
      Ok((@symlogic.bool_and(args), index))
    }
  }
}

///|
fn logic_parse_xor(
  tokens : Array[LogicToken],
  start : Int,
) -> Result[(@symlogic.BoolExpr, Int), String] {
  let parsed = logic_parse_and(tokens, start)
  match parsed {
    Err(message) => Err(message)
    Ok((first, next)) => {
      let args : Array[@symlogic.BoolExpr] = [first]
      let mut index = next
      while tokens[index] == LogicToken::Xor {
        let rhs = logic_parse_and(tokens, index + 1)
        match rhs {
          Err(message) => return Err(message)
          Ok((expr, next_rhs)) => {
            args.push(expr)
            index = next_rhs
          }
        }
      }
      Ok((@symlogic.bool_xor(args), index))
    }
  }
}

///|
fn logic_parse_or(
  tokens : Array[LogicToken],
  start : Int,
) -> Result[(@symlogic.BoolExpr, Int), String] {
  let parsed = logic_parse_xor(tokens, start)
  match parsed {
    Err(message) => Err(message)
    Ok((first, next)) => {
      let args : Array[@symlogic.BoolExpr] = [first]
      let mut index = next
      while tokens[index] == LogicToken::Or {
        let rhs = logic_parse_xor(tokens, index + 1)
        match rhs {
          Err(message) => return Err(message)
          Ok((expr, next_rhs)) => {
            args.push(expr)
            index = next_rhs
          }
        }
      }
      Ok((@symlogic.bool_or(args), index))
    }
  }
}

///|
fn parse_logic_expr_source(
  source : String,
) -> Result[@symlogic.BoolExpr, String] {
  let tokens_result = logic_lex(source)
  match tokens_result {
    Err(message) => Err(message)
    Ok(tokens) =>
      match logic_parse_or(tokens, 0) {
        Err(message) => Err(message)
        Ok((expr, next)) =>
          match tokens[next] {
            LogicToken::Eof => Ok(expr)
            _ => Err("Unexpected trailing tokens in logic expression.")
          }
      }
  }
}
