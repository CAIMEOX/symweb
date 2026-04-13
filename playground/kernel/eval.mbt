///|
fn parser_settings_to_options(
  settings : @common.ParserSettings,
) -> @symparse.ParseOptions {
  let transformations : Array[@symparse.Transformation] = [
    @symparse.Transformation::LambdaNotation,
    @symparse.Transformation::AutoSymbol,
    @symparse.Transformation::RepeatedDecimals,
    @symparse.Transformation::AutoNumber,
  ]
  if settings.factorial_notation {
    transformations.push(@symparse.Transformation::FactorialNotation)
  }
  if settings.caret_as_power {
    transformations.push(@symparse.Transformation::ConvertXor)
  }
  if settings.implicit_multiplication &&
    settings.implicit_application &&
    settings.function_exponentiation {
    transformations.push(
      @symparse.Transformation::ImplicitMultiplicationApplication,
    )
  } else {
    if settings.implicit_multiplication {
      transformations.push(@symparse.Transformation::ImplicitMultiplication)
    }
    if settings.implicit_application {
      transformations.push(@symparse.Transformation::ImplicitApplication)
    }
    if settings.function_exponentiation {
      transformations.push(@symparse.Transformation::FunctionExponentiation)
    }
  }
  if settings.convert_equals_signs {
    transformations.push(@symparse.Transformation::ConvertEqualsSigns)
  }
  @symparse.parse_options(transformations~, evaluate=settings.evaluate)
}

///|
fn span_text(span : @symparse.Span) -> String {
  "chars \{span.start}..\{span.stop}"
}

///|
fn parse_error_message(error : @symparse.ParseError) -> String {
  match error {
    UnexpectedChar(span~, ch) =>
      "Unexpected character '\{ch}' at \{span_text(span)}."
    UnexpectedToken(span~, expected, actual) =>
      "Unexpected token \{actual}; expected \{expected} at \{span_text(span)}."
    UnexpectedEof(span~, expected) =>
      "Unexpected end of input; expected \{expected} at \{span_text(span)}."
    InvalidNumber(span~, text) =>
      "Invalid numeric literal \{text} at \{span_text(span)}."
    UnsupportedConstruct(span~, text) =>
      "Unsupported construct \{text} at \{span_text(span)}."
  }
}

///|
fn normalize_output(text : String) -> String {
  text
  .replace_all(old=" + -", new=" - ")
  .replace_all(old="-1*", new="-")
  .replace_all(old="1*", new="")
}

///|
fn expr_text(expr : @symbit.Expr) -> String {
  normalize_output(@symbit.to_string(expr))
}

///|
fn expr_latex(expr : @symbit.Expr) -> String {
  @symprint.latex(expr)
}

///|
fn bool_field(label : String, expr : @symlogic.BoolExpr) -> @common.ResultField {
  plain_field(label, logic_expr_text(expr))
}

///|
fn sat_result_field(
  label : String,
  result : @symlogic.SatResult,
) -> @common.ResultField {
  plain_field(label, result.to_string())
}

///|
fn expr_list_text(items : Array[@symbit.Expr]) -> String {
  "[" + items.map(expr_text).join(", ") + "]"
}

///|
fn expr_list_latex(items : Array[@symbit.Expr]) -> String {
  "\\left[" + items.map(expr_latex).join(", ") + "\\right]"
}

///|
fn dict_text(values : Map[String, @symbit.Expr]) -> String {
  let names : Array[String] = []
  for name, _ in values {
    names.push(name)
  }
  names.sort()
  let items : Array[String] = []
  for name in names {
    items.push(name + ": " + expr_text(values[name]))
  }
  "{" + items.join(", ") + "}"
}

///|
fn solve_result_text(result : @symsolvers.SolveResult) -> String {
  match result {
    List(items) => expr_list_text(items)
    Dict(values) => dict_text(values)
    Dicts(items) => {
      let rendered : Array[String] = []
      for item in items {
        rendered.push(dict_text(item))
      }
      "[" + rendered.join(", ") + "]"
    }
  }
}

///|
fn set_text(set : @symsets.Set) -> String {
  normalize_output(@symsets.to_string(set))
}

///|
fn set_field(label : String, set : @symsets.Set) -> @common.ResultField {
  plain_field(label, set_text(set))
}

///|
fn set_bool_text(value : @symsets.SetBool) -> String {
  match value {
    @symsets.SetBool::True => "True"
    @symsets.SetBool::False => "False"
    @symsets.SetBool::Unknown => "Unknown"
  }
}

///|
fn tri_text(value : @symassume.Tri) -> String {
  match value {
    @symassume.Tri::True => "True"
    @symassume.Tri::False => "False"
    @symassume.Tri::Unknown => "Unknown"
  }
}

///|
fn dense_matrix_text(matrix : @symmatrices.Matrix) -> String {
  normalize_output(matrix.to_string())
}

///|
fn dense_matrix_latex(matrix : @symmatrices.Matrix) -> String {
  matrix.latex()
}

///|
fn dense_matrix_field(
  label : String,
  matrix : @symmatrices.Matrix,
) -> @common.ResultField {
  latex_field(label, dense_matrix_text(matrix), dense_matrix_latex(matrix))
}

///|
fn matrix_shape_text(matrix : @symmatrices.Matrix) -> String {
  let (rows, cols) = matrix.shape()
  "(\{rows}, \{cols})"
}

///|
fn matrix_from_row_args(
  row_exprs : Array[@symbit.Expr],
  usage : String,
) -> Result[@symmatrices.Matrix, String] {
  if row_exprs.is_empty() {
    return Err("Expected nested tuple rows in \{usage}.")
  }
  let rows : Array[Array[@symbit.Expr]] = []
  for row_expr in row_exprs {
    match @symcore.tuple_items(row_expr) {
      Some(items) => rows.push(items)
      None => return Err("Expected each matrix row to be a tuple in \{usage}.")
    }
  }
  let matrix_result : Result[@symmatrices.Matrix, @symmatrices.MatrixError] = try? @symmatrices.matrix(
    rows,
  )
  match matrix_result {
    Err(error) => Err(error.to_string())
    Ok(matrix) => Ok(matrix)
  }
}

///|
fn matrix_from_expr(
  expr : @symbit.Expr,
  usage : String,
) -> Result[@symmatrices.Matrix, String] {
  match @symcore.tuple_items(expr) {
    Some(items) => {
      let mut nested_rows = true
      for item in items {
        if @symcore.tuple_items(item) is None {
          nested_rows = false
          break
        }
      }
      if nested_rows {
        matrix_from_row_args(items, usage)
      } else {
        let rows = items.map(fn(item) { [item] })
        let matrix_result : Result[
          @symmatrices.Matrix,
          @symmatrices.MatrixError,
        ] = try? @symmatrices.matrix(rows)
        match matrix_result {
          Err(error) => Err(error.to_string())
          Ok(matrix) => Ok(matrix)
        }
      }
    }
    None => Err("Expected tuple-shaped matrix input in \{usage}.")
  }
}

///|
fn poly_text(poly : @sympolys.Poly) -> String {
  expr_text(poly.to_expr())
}

///|
fn poly_list_text(items : Array[@sympolys.Poly]) -> String {
  "[" + items.map(poly_text).join(", ") + "]"
}

///|
fn poly_list_latex(items : Array[@sympolys.Poly]) -> String {
  expr_list_latex(items.map(fn(poly) { poly.to_expr() }))
}

///|
fn explicit_matrix_text(matrix : @symphysics.ExplicitMatrix) -> String {
  @symphysics.explicit_matrix_rows_string(matrix)
}

///|
fn explicit_matrix_latex(matrix : @symphysics.ExplicitMatrix) -> String {
  let rows : Array[String] = []
  for row in matrix.rows_copy() {
    rows.push(row.map(expr_latex).join(" & "))
  }
  "\\begin{bmatrix}" + rows.join(" \\\\ ") + "\\end{bmatrix}"
}

///|
fn ray_transfer_matrix_text(matrix : @symphysics.RayTransferMatrix) -> String {
  @symphysics.explicit_matrix_rows_string(matrix.matrix())
}

///|
fn ray_transfer_matrix_latex(matrix : @symphysics.RayTransferMatrix) -> String {
  explicit_matrix_latex(matrix.matrix())
}

///|
fn expr_args(expr : @symbit.Expr) -> Array[@symbit.Expr] {
  match @symcore.tuple_items(expr) {
    Some(items) => items
    None => [expr]
  }
}

///|
fn exact_int(expr : @symbit.Expr) -> Int? {
  match expr {
    @symcore.Expr::Number(value) if value.is_integral() =>
      Some(value.numerator().to_int())
    _ => None
  }
}

///|
fn exact_bigint(expr : @symbit.Expr) -> @symntheory.BigInt? {
  match exact_int(expr) {
    Some(value) => Some(@symntheory.bi(value))
    None => None
  }
}

///|
fn integer_arg_list_text(args : Array[Int]) -> String {
  "[" + args.map(fn(i) { i.to_string() }).join(", ") + "]"
}

///|
fn factorint_text(values : Map[@symntheory.BigInt, Int]) -> String {
  let keys : Array[@symntheory.BigInt] = []
  for key, _ in values {
    keys.push(key)
  }
  keys.sort()
  let items : Array[String] = []
  for key in keys {
    items.push(key.to_string() + ": " + values[key].to_string())
  }
  "{" + items.join(", ") + "}"
}

///|
fn require_arg_count(
  args : Array[@symbit.Expr],
  allowed : Array[Int],
  usage : String,
) -> Result[Unit, String] {
  for arity in allowed {
    if args.length() == arity {
      return Ok(())
    }
  }
  let expected = allowed.map(fn(n) { n.to_string() }).join(" or ")
  Err("Expected \{expected} argument(s) in \{usage}.")
}

///|
fn require_int_args(
  args : Array[@symbit.Expr],
  usage : String,
) -> Result[Array[Int], String] {
  let ints : Array[Int] = []
  for arg in args {
    match exact_int(arg) {
      Some(value) => ints.push(value)
      None =>
        return Err(
          "Expected exact integer arguments in \{usage}; got \{expr_text(arg)}.",
        )
    }
  }
  Ok(ints)
}

///|
fn plain_field(label : String, value : String) -> @common.ResultField {
  { label, value, latex: None }
}

///|
fn latex_field(
  label : String,
  value : String,
  latex : String,
) -> @common.ResultField {
  { label, value, latex: Some(latex) }
}

///|
fn expr_field(label : String, expr : @symbit.Expr) -> @common.ResultField {
  latex_field(label, expr_text(expr), expr_latex(expr))
}

///|
fn expr_list_field(
  label : String,
  items : Array[@symbit.Expr],
) -> @common.ResultField {
  latex_field(label, expr_list_text(items), expr_list_latex(items))
}

///|
fn poly_field(label : String, poly : @sympolys.Poly) -> @common.ResultField {
  expr_field(label, poly.to_expr())
}

///|
fn poly_list_field(
  label : String,
  items : Array[@sympolys.Poly],
) -> @common.ResultField {
  latex_field(label, poly_list_text(items), poly_list_latex(items))
}

///|
fn rational_expr(value : @symnum.BigRational) -> @symbit.Expr {
  @symcore.Expr::Number(value)
}

///|
fn factor_pairs_text(items : Array[(@sympolys.Poly, Int)]) -> String {
  let rendered : Array[String] = []
  for item in items {
    let (poly, multiplicity) = item
    rendered.push("(\{poly_text(poly)}, \{multiplicity})")
  }
  "[" + rendered.join(", ") + "]"
}

///|
fn factor_pairs_latex(items : Array[(@sympolys.Poly, Int)]) -> String {
  let rendered : Array[String] = []
  for item in items {
    let (poly, multiplicity) = item
    rendered.push(
      "\\left(" +
      expr_latex(poly.to_expr()) +
      ", " +
      multiplicity.to_string() +
      "\\right)",
    )
  }
  "\\left[" + rendered.join(", ") + "\\right]"
}

///|
fn factor_list_text(
  content : @symnum.BigRational,
  items : Array[(@sympolys.Poly, Int)],
) -> String {
  "(\{expr_text(rational_expr(content))}, \{factor_pairs_text(items)})"
}

///|
fn factor_list_latex(
  content : @symnum.BigRational,
  items : Array[(@sympolys.Poly, Int)],
) -> String {
  "\\left(" +
  expr_latex(rational_expr(content)) +
  ", " +
  factor_pairs_latex(items) +
  "\\right)"
}

///|
fn factor_list_field(
  label : String,
  content : @symnum.BigRational,
  items : Array[(@sympolys.Poly, Int)],
) -> @common.ResultField {
  latex_field(
    label,
    factor_list_text(content, items),
    factor_list_latex(content, items),
  )
}

///|
fn normalize_groebner_basis_for_display(
  items : Array[@sympolys.Poly],
) -> Result[Array[@sympolys.Poly], @sympolys.PolyError] {
  let normalized : Array[@sympolys.Poly] = []
  for item in items {
    if item.domain is @sympolys.Domain::QQ {
      let cleared_result : Result[@sympolys.Poly, @sympolys.PolyError] = try? @sympolys.clear_denominators(
        item,
      )
      match cleared_result {
        Err(error) => return Err(error)
        Ok(cleared) => {
          let primitive_result : Result[@sympolys.Poly, @sympolys.PolyError] = try? cleared.primitive_part()
          match primitive_result {
            Err(error) => return Err(error)
            Ok(primitive) => normalized.push(primitive)
          }
        }
      }
    } else {
      normalized.push(item)
    }
  }
  Ok(normalized)
}

///|
fn factor_product_expr(
  content : @symnum.BigRational,
  items : Array[(@sympolys.Poly, Int)],
) -> @symbit.Expr {
  let factors : Array[@symbit.Expr] = []
  if !content.is_one() || items.is_empty() {
    factors.push(rational_expr(content))
  }
  for item in items {
    let (poly, multiplicity) = item
    let poly_expr = poly.to_expr()
    factors.push(
      if multiplicity == 1 {
        poly_expr
      } else {
        @symcore.pow(poly_expr, @symcore.int(multiplicity))
      },
    )
  }
  if factors.length() == 1 {
    factors[0]
  } else {
    @symcore.mul(factors)
  }
}

///|
fn quotient_expr(num : @sympolys.Poly, den : @sympolys.Poly) -> @symbit.Expr {
  let numerator = num.to_expr()
  let denominator = den.to_expr()
  if denominator == @symcore.int(1) {
    numerator
  } else {
    @symcore.mul([numerator, @symcore.pow(denominator, @symcore.int(-1))])
  }
}

///|
fn symbol_name(expr : @symbit.Expr) -> String? {
  match expr {
    @symcore.Expr::Symbol(name) => Some(name)
    _ => None
  }
}

///|
fn infer_poly_gens(exprs : Array[@symbit.Expr]) -> Array[String] {
  let names : Array[String] = []
  for expr in exprs {
    for sym in @symcore.free_symbols(expr) {
      let name = match symbol_name(sym) {
        Some(value) => value
        None => @symbit.to_string(sym)
      }
      let mut seen = false
      for existing in names {
        if existing == name {
          seen = true
          break
        }
      }
      if !seen {
        names.push(name)
      }
    }
  }
  names.sort()
  names
}

///|
fn poly_from_expr_shared(
  expr : @symbit.Expr,
  gens : Array[String],
) -> Result[@sympolys.Poly, @sympolys.PolyError] {
  if gens.is_empty() {
    try? @sympolys.Poly::from_expr_defaults(expr)
  } else {
    try? @sympolys.Poly::from_expr_defaults(expr, gens~)
  }
}

///|
fn poly_list_from_exprs(
  exprs : Array[@symbit.Expr],
) -> Result[(Array[@sympolys.Poly], Array[String]), @sympolys.PolyError] {
  let gens = infer_poly_gens(exprs)
  let polys : Array[@sympolys.Poly] = []
  for expr in exprs {
    let poly_result : Result[@sympolys.Poly, @sympolys.PolyError] = poly_from_expr_shared(
      expr, gens,
    )
    match poly_result {
      Err(error) => return Err(error)
      Ok(poly) => polys.push(poly)
    }
  }
  Ok((polys, gens))
}

///|
fn principal_poly_gen(gens : Array[String]) -> String {
  for name in gens {
    if name == "x" {
      return name
    }
  }
  if gens.is_empty() {
    "x"
  } else {
    gens[0]
  }
}

///|
fn matrix_field(
  label : String,
  matrix : @symphysics.ExplicitMatrix,
) -> @common.ResultField {
  latex_field(
    label,
    explicit_matrix_text(matrix),
    explicit_matrix_latex(matrix),
  )
}

///|
fn ray_transfer_matrix_field(
  label : String,
  matrix : @symphysics.RayTransferMatrix,
) -> @common.ResultField {
  latex_field(
    label,
    ray_transfer_matrix_text(matrix),
    ray_transfer_matrix_latex(matrix),
  )
}

///|
fn x_symbol() -> @symbit.Expr {
  @symbit.sympify_name("x")
}

///|
fn t_symbol() -> @symbit.Expr {
  @symbit.sympify_name("t")
}

///|
fn s_symbol() -> @symbit.Expr {
  @symbit.sympify_name("s")
}

///|
fn k_symbol() -> @symbit.Expr {
  @symbit.sympify_name("k")
}

///|
fn lambda_symbol() -> @symbit.Expr {
  @symbit.sympify_name("lambda")
}

///|
fn unknown_function(function_id : String) -> @common.KernelEvalState {
  @common.KernelEvalState::Failure("Unknown function id: \{function_id}")
}

///|
pub fn evaluate_request(
  request : @common.KernelRequest,
) -> @common.KernelEvalState {
  let trimmed = request.source.trim()
  if trimmed == "" {
    return @common.KernelEvalState::Failure(
      "Enter a symbolic expression before running the reference example.",
    )
  }
  if is_logic_function_id(request.function_id) {
    let logic_result = parse_logic_expr_source(trimmed.to_string())
    match logic_result {
      Err(message) => return @common.KernelEvalState::Failure(message)
      Ok(bool_expr) => {
        let parsed_expression = logic_expr_text(bool_expr)
        let structural_form = logic_expr_structural_form(bool_expr)
        let finish_logic = fn(fields : Array[@common.ResultField]) {
          @common.KernelEvalState::Success({
            parsed_expression,
            parsed_latex: None,
            structural_form,
            fields,
          })
        }
        return match request.function_id {
          "logic_simplify" =>
            finish_logic([
              bool_field("Result", @symlogic.simplify_logic(bool_expr)),
            ])
          "logic_to_cnf" =>
            finish_logic([bool_field("Result", @symlogic.to_cnf(bool_expr))])
          "logic_to_dnf" =>
            finish_logic([bool_field("Result", @symlogic.to_dnf(bool_expr))])
          "logic_satisfiable" =>
            finish_logic([
              sat_result_field("Result", @symlogic.satisfiable(bool_expr)),
            ])
          _ => unknown_function(request.function_id)
        }
      }
    }
  }
  let options = parser_settings_to_options(request.parser)
  let parsed_result : Result[@symbit.Expr, @symparse.ParseError] = try? @symparse.parse_expr_with(
    trimmed.to_string(),
    options,
  )
  match parsed_result {
    Err(error) => @common.KernelEvalState::Failure(parse_error_message(error))
    Ok(expr) => {
      let parsed_expression = expr_text(expr)
      let parsed_latex = expr_latex(expr)
      let structural_form = @symbit.debug_repr(expr)
      let args = expr_args(expr)
      let finish = fn(fields : Array[@common.ResultField]) {
        @common.KernelEvalState::Success({
          parsed_expression,
          parsed_latex: Some(parsed_latex),
          structural_form,
          fields,
        })
      }
      match request.function_id {
        "simplify" => finish([expr_field("Result", @symbit.simplify(expr))])
        "trigsimp" => finish([expr_field("Result", @symbit.trigsimp(expr))])
        "ratsimp" => finish([expr_field("Result", @symbit.ratsimp(expr))])
        "diff" => {
          let wrt = x_symbol()
          finish([
            expr_field("Variable", wrt),
            expr_field("Result", @symcalculus.diff(expr, wrt)),
          ])
        }
        "periodicity" => {
          let wrt = x_symbol()
          let fields = match @symcalculus.periodicity(expr, wrt) {
            Some(period) =>
              [expr_field("Variable", wrt), expr_field("Result", period)]
            None =>
              [
                expr_field("Variable", wrt),
                plain_field("Result", "No finite period found."),
              ]
          }
          finish(fields)
        }
        "singularities" => {
          let wrt = x_symbol()
          finish([
            expr_field("Variable", wrt),
            expr_field("Result", @symcalculus.singularities(expr, wrt)),
          ])
        }
        "integrate" => {
          let wrt = x_symbol()
          finish([
            expr_field("Variable", wrt),
            expr_field("Result", @symintegrals.integrate(expr, limits=[wrt])),
          ])
        }
        "laplace_transform" => {
          let (target, source, transform) = match args {
            [integrand] => (integrand, t_symbol(), s_symbol())
            [integrand, time_var, transform_var] =>
              (integrand, time_var, transform_var)
            _ =>
              return @common.KernelEvalState::Failure(
                "Expected laplace_transform(expr) or laplace_transform(expr, t, s).",
              )
          }
          finish([
            expr_field("Source Variable", source),
            expr_field("Transform Variable", transform),
            expr_field(
              "Result",
              @symintegrals.laplace_transform_eval(target, source, transform),
            ),
          ])
        }
        "inverse_laplace_transform" => {
          let (target, transform, source) = match args {
            [image] => (image, s_symbol(), t_symbol())
            [image, transform_var, time_var] => (image, transform_var, time_var)
            _ =>
              return @common.KernelEvalState::Failure(
                "Expected inverse_laplace_transform(expr) or inverse_laplace_transform(expr, s, t).",
              )
          }
          finish([
            expr_field("Transform Variable", transform),
            expr_field("Source Variable", source),
            expr_field(
              "Result",
              @symintegrals.inverse_laplace_transform_eval(
                target,
                transform,
                source,
                noconds=true,
              ),
            ),
          ])
        }
        "series" => {
          let wrt = x_symbol()
          let around = @symcore.int(0)
          let series_result : Result[@symbit.Expr, Error] = try? @symseries.series(
            expr,
            x=wrt,
            x0=around,
            n=6,
            dir="+",
          )
          match series_result {
            Err(error) => @common.KernelEvalState::Failure(error.to_string())
            Ok(result) =>
              finish([
                expr_field("Variable", wrt),
                expr_field("Expansion Point", around),
                expr_field("Result", result),
              ])
          }
        }
        "limit" => {
          let wrt = x_symbol()
          let point = @symcore.int(0)
          let limit_result : Result[@symbit.Expr, Error] = try? @symseries.limit(
            expr,
            wrt,
            point,
            dir="+",
          )
          match limit_result {
            Err(error) => @common.KernelEvalState::Failure(error.to_string())
            Ok(result) =>
              finish([
                expr_field("Variable", wrt),
                expr_field("Approach Point", point),
                plain_field("Direction", "+"),
                expr_field("Result", result),
              ])
          }
        }
        "residue" => {
          let wrt = x_symbol()
          let point = @symcore.int(0)
          let residue_result : Result[@symbit.Expr, Error] = try? @symseries.residue(
            expr, wrt, point,
          )
          match residue_result {
            Err(error) => @common.KernelEvalState::Failure(error.to_string())
            Ok(result) =>
              finish([
                expr_field("Variable", wrt),
                expr_field("Pole", point),
                expr_field("Result", result),
              ])
          }
        }
        "assume_is_integer" =>
          finish([
            expr_field("Input", expr),
            plain_field("Result", tri_text(@symassume.is_integer(expr))),
          ])
        "assume_is_real" =>
          finish([
            expr_field("Input", expr),
            plain_field("Result", tri_text(@symassume.is_real(expr))),
          ])
        "assume_is_positive" =>
          finish([
            expr_field("Input", expr),
            plain_field("Result", tri_text(@symassume.is_positive(expr))),
          ])
        "set_interval" =>
          match require_arg_count(args, [2], "interval(left, right)") {
            Err(message) => @common.KernelEvalState::Failure(message)
            Ok(_) =>
              finish([
                expr_list_field("Endpoints", args),
                set_field("Result", @symsets.interval(args[0], args[1])),
              ])
          }
        "set_finite" =>
          if args.is_empty() {
            @common.KernelEvalState::Failure(
              "Expected at least 1 argument in finite_set(a1, a2, ...).",
            )
          } else {
            finish([
              expr_list_field("Elements", args),
              set_field("Result", @symsets.finite_set(args)),
            ])
          }
        "set_contains" =>
          match require_arg_count(args, [3], "contains(value, left, right)") {
            Err(message) => @common.KernelEvalState::Failure(message)
            Ok(_) => {
              let base = @symsets.interval(args[1], args[2])
              finish([
                expr_field("Value", args[0]),
                set_field("Set", base),
                plain_field(
                  "Result",
                  set_bool_text(@symsets.contains(base, args[0])),
                ),
              ])
            }
          }
        "summation" =>
          match require_arg_count(args, [3], "summation(term, lower, upper)") {
            Err(message) => @common.KernelEvalState::Failure(message)
            Ok(_) => {
              let index = k_symbol()
              let limit = @symconcrete.limit_range(index, args[1], args[2])
              finish([
                expr_field("Index", index),
                expr_field("Term", args[0]),
                expr_field(
                  "Result",
                  @symconcrete.summation(args[0], limits=[limit]),
                ),
              ])
            }
          }
        "product" =>
          match require_arg_count(args, [3], "product(term, lower, upper)") {
            Err(message) => @common.KernelEvalState::Failure(message)
            Ok(_) => {
              let index = k_symbol()
              let limit = @symconcrete.limit_range(index, args[1], args[2])
              finish([
                expr_field("Index", index),
                expr_field("Term", args[0]),
                expr_field(
                  "Result",
                  @symconcrete.product(args[0], limits=[limit]),
                ),
              ])
            }
          }
        "rationalize" =>
          finish([
            expr_field("Input", expr),
            expr_field("Result", @symconcrete.rationalize(expr)),
          ])
        "discrete_fft" =>
          if args.is_empty() {
            @common.KernelEvalState::Failure(
              "Expected at least 1 argument in fft(a0, a1, ...).",
            )
          } else {
            let result : Result[Array[@symbit.Expr], @symdiscrete.DiscreteError] = try? @symdiscrete.fft(
              args,
            )
            match result {
              Err(error) => @common.KernelEvalState::Failure(error.to_string())
              Ok(values) =>
                finish([
                  expr_list_field("Sequence", args),
                  expr_list_field("Result", values),
                ])
            }
          }
        "discrete_ifft" =>
          if args.is_empty() {
            @common.KernelEvalState::Failure(
              "Expected at least 1 argument in ifft(a0, a1, ...).",
            )
          } else {
            let result : Result[Array[@symbit.Expr], @symdiscrete.DiscreteError] = try? @symdiscrete.ifft(
              args,
            )
            match result {
              Err(error) => @common.KernelEvalState::Failure(error.to_string())
              Ok(values) =>
                finish([
                  expr_list_field("Sequence", args),
                  expr_list_field("Result", values),
                ])
            }
          }
        "discrete_fwht" =>
          if args.is_empty() {
            @common.KernelEvalState::Failure(
              "Expected at least 1 argument in fwht(a0, a1, ...).",
            )
          } else {
            finish([
              expr_list_field("Sequence", args),
              expr_list_field("Result", @symdiscrete.fwht(args)),
            ])
          }
        "discrete_mobius" =>
          if args.is_empty() {
            @common.KernelEvalState::Failure(
              "Expected at least 1 argument in mobius_transform(a0, a1, ...).",
            )
          } else {
            finish([
              expr_list_field("Sequence", args),
              expr_list_field("Result", @symdiscrete.mobius_transform(args)),
            ])
          }
        "matrix_construct" =>
          match matrix_from_row_args(args, "matrix(((...), (...), ...))") {
            Err(message) => @common.KernelEvalState::Failure(message)
            Ok(matrix) =>
              finish([
                plain_field("Shape", matrix_shape_text(matrix)),
                dense_matrix_field("Result", matrix),
              ])
          }
        "matrix_eye" =>
          match require_arg_count(args, [1], "eye(n)") {
            Err(message) => @common.KernelEvalState::Failure(message)
            Ok(_) =>
              match require_int_args(args, "eye(n)") {
                Err(message) => @common.KernelEvalState::Failure(message)
                Ok(values) => {
                  let matrix_result : Result[
                    @symmatrices.Matrix,
                    @symmatrices.MatrixError,
                  ] = try? @symmatrices.eye(values[0])
                  match matrix_result {
                    Err(error) =>
                      @common.KernelEvalState::Failure(error.to_string())
                    Ok(matrix) =>
                      finish([
                        plain_field("Shape", matrix_shape_text(matrix)),
                        dense_matrix_field("Result", matrix),
                      ])
                  }
                }
              }
          }
        "matrix_zeros" =>
          match
            require_arg_count(args, [1, 2], "zeros(n) or zeros(rows, cols)") {
            Err(message) => @common.KernelEvalState::Failure(message)
            Ok(_) =>
              match require_int_args(args, "zeros(n) or zeros(rows, cols)") {
                Err(message) => @common.KernelEvalState::Failure(message)
                Ok(values) => {
                  let matrix_result : Result[
                    @symmatrices.Matrix,
                    @symmatrices.MatrixError,
                  ] = match values {
                    [rows] => try? @symmatrices.zeros(rows)
                    [rows, cols] =>
                      try? @symmatrices.zeros(rows, cols=Some(cols))
                    _ =>
                      Err(@symmatrices.MatrixError::ValueError("unreachable"))
                  }
                  match matrix_result {
                    Err(error) =>
                      @common.KernelEvalState::Failure(error.to_string())
                    Ok(matrix) =>
                      finish([
                        plain_field("Shape", matrix_shape_text(matrix)),
                        dense_matrix_field("Result", matrix),
                      ])
                  }
                }
              }
          }
        "matrix_ones" =>
          match require_arg_count(args, [1, 2], "ones(n) or ones(rows, cols)") {
            Err(message) => @common.KernelEvalState::Failure(message)
            Ok(_) =>
              match require_int_args(args, "ones(n) or ones(rows, cols)") {
                Err(message) => @common.KernelEvalState::Failure(message)
                Ok(values) => {
                  let matrix_result : Result[
                    @symmatrices.Matrix,
                    @symmatrices.MatrixError,
                  ] = match values {
                    [rows] => try? @symmatrices.ones(rows)
                    [rows, cols] =>
                      try? @symmatrices.ones(rows, cols=Some(cols))
                    _ =>
                      Err(@symmatrices.MatrixError::ValueError("unreachable"))
                  }
                  match matrix_result {
                    Err(error) =>
                      @common.KernelEvalState::Failure(error.to_string())
                    Ok(matrix) =>
                      finish([
                        plain_field("Shape", matrix_shape_text(matrix)),
                        dense_matrix_field("Result", matrix),
                      ])
                  }
                }
              }
          }
        "matrix_det" =>
          match matrix_from_row_args(args, "det(((...), (...), ...))") {
            Err(message) => @common.KernelEvalState::Failure(message)
            Ok(matrix) => {
              let det_result : Result[@symbit.Expr, @symmatrices.MatrixError] = try? matrix.det()
              match det_result {
                Err(error) =>
                  @common.KernelEvalState::Failure(error.to_string())
                Ok(value) =>
                  finish([
                    dense_matrix_field("Matrix", matrix),
                    expr_field("Result", value),
                  ])
              }
            }
          }
        "matrix_trace" =>
          match matrix_from_row_args(args, "trace(((...), (...), ...))") {
            Err(message) => @common.KernelEvalState::Failure(message)
            Ok(matrix) => {
              let trace_result : Result[@symbit.Expr, @symmatrices.MatrixError] = try? matrix.trace()
              match trace_result {
                Err(error) =>
                  @common.KernelEvalState::Failure(error.to_string())
                Ok(value) =>
                  finish([
                    dense_matrix_field("Matrix", matrix),
                    expr_field("Result", value),
                  ])
              }
            }
          }
        "matrix_inv" =>
          match matrix_from_row_args(args, "inv(((...), (...), ...))") {
            Err(message) => @common.KernelEvalState::Failure(message)
            Ok(matrix) => {
              let inv_result : Result[
                @symmatrices.Matrix,
                @symmatrices.MatrixError,
              ] = try? matrix.inv()
              match inv_result {
                Err(error) =>
                  @common.KernelEvalState::Failure(error.to_string())
                Ok(value) =>
                  finish([
                    dense_matrix_field("Matrix", matrix),
                    dense_matrix_field("Result", value),
                  ])
              }
            }
          }
        "matrix_rank" =>
          match matrix_from_row_args(args, "rank(((...), (...), ...))") {
            Err(message) => @common.KernelEvalState::Failure(message)
            Ok(matrix) =>
              finish([
                dense_matrix_field("Matrix", matrix),
                plain_field("Result", matrix.rank().to_string()),
              ])
          }
        "matrix_charpoly" =>
          match matrix_from_row_args(args, "charpoly(((...), (...), ...))") {
            Err(message) => @common.KernelEvalState::Failure(message)
            Ok(matrix) => {
              let symbol = lambda_symbol()
              let charpoly_result : Result[
                @symbit.Expr,
                @symmatrices.MatrixError,
              ] = try? matrix.charpoly(x=symbol)
              match charpoly_result {
                Err(error) =>
                  @common.KernelEvalState::Failure(error.to_string())
                Ok(value) =>
                  finish([
                    dense_matrix_field("Matrix", matrix),
                    expr_field("Variable", symbol),
                    expr_field("Result", value),
                  ])
              }
            }
          }
        "matrix_solve" =>
          match require_arg_count(args, [2], "matrix_solve(matrix, rhs)") {
            Err(message) => @common.KernelEvalState::Failure(message)
            Ok(_) =>
              match matrix_from_expr(args[0], "matrix_solve(matrix, rhs)") {
                Err(message) => @common.KernelEvalState::Failure(message)
                Ok(matrix) =>
                  match matrix_from_expr(args[1], "matrix_solve(matrix, rhs)") {
                    Err(message) => @common.KernelEvalState::Failure(message)
                    Ok(rhs) => {
                      let solve_result : Result[
                        @symmatrices.Matrix,
                        @symmatrices.MatrixError,
                      ] = try? matrix.solve(rhs)
                      match solve_result {
                        Err(error) =>
                          @common.KernelEvalState::Failure(error.to_string())
                        Ok(value) =>
                          finish([
                            dense_matrix_field("Matrix", matrix),
                            dense_matrix_field("Right-Hand Side", rhs),
                            dense_matrix_field("Result", value),
                          ])
                      }
                    }
                  }
              }
          }
        "terms_gcd" => {
          let poly_result : Result[@sympolys.Poly, @sympolys.PolyError] = try? @sympolys.Poly::from_expr_defaults(
            expr,
          )
          match poly_result {
            Err(error) => @common.KernelEvalState::Failure(error.to_string())
            Ok(poly) => {
              let reduced_result : Result[@sympolys.Poly, @sympolys.PolyError] = try? @sympolys.terms_gcd(
                poly,
              )
              match reduced_result {
                Err(error) =>
                  @common.KernelEvalState::Failure(error.to_string())
                Ok(reduced) =>
                  finish([
                    poly_field("Poly Form", poly),
                    poly_field("Result", reduced),
                  ])
              }
            }
          }
        }
        "poly_factor" => {
          let poly_result : Result[@sympolys.Poly, @sympolys.PolyError] = try? @sympolys.Poly::from_expr_defaults(
            expr,
          )
          match poly_result {
            Err(error) => @common.KernelEvalState::Failure(error.to_string())
            Ok(poly) => {
              let factor_result : Result[
                (@symnum.BigRational, Array[(@sympolys.Poly, Int)]),
                @sympolys.PolyError,
              ] = try? poly.factor_list()
              match factor_result {
                Err(error) =>
                  @common.KernelEvalState::Failure(error.to_string())
                Ok((content, factors)) =>
                  finish([
                    poly_field("Poly Form", poly),
                    expr_field("Result", factor_product_expr(content, factors)),
                  ])
              }
            }
          }
        }
        "poly_factor_list" => {
          let poly_result : Result[@sympolys.Poly, @sympolys.PolyError] = try? @sympolys.Poly::from_expr_defaults(
            expr,
          )
          match poly_result {
            Err(error) => @common.KernelEvalState::Failure(error.to_string())
            Ok(poly) => {
              let factor_result : Result[
                (@symnum.BigRational, Array[(@sympolys.Poly, Int)]),
                @sympolys.PolyError,
              ] = try? poly.factor_list()
              match factor_result {
                Err(error) =>
                  @common.KernelEvalState::Failure(error.to_string())
                Ok((content, factors)) =>
                  finish([
                    poly_field("Poly Form", poly),
                    factor_list_field("Result", content, factors),
                  ])
              }
            }
          }
        }
        "poly_sqf_part" => {
          let poly_result : Result[@sympolys.Poly, @sympolys.PolyError] = try? @sympolys.Poly::from_expr_defaults(
            expr,
          )
          match poly_result {
            Err(error) => @common.KernelEvalState::Failure(error.to_string())
            Ok(poly) => {
              let sqf_part_result : Result[@sympolys.Poly, @sympolys.PolyError] = try? poly.sqf_part()
              match sqf_part_result {
                Err(error) =>
                  @common.KernelEvalState::Failure(error.to_string())
                Ok(result) =>
                  finish([
                    poly_field("Poly Form", poly),
                    poly_field("Result", result),
                  ])
              }
            }
          }
        }
        "poly_sqf_list" => {
          let poly_result : Result[@sympolys.Poly, @sympolys.PolyError] = try? @sympolys.Poly::from_expr_defaults(
            expr,
          )
          match poly_result {
            Err(error) => @common.KernelEvalState::Failure(error.to_string())
            Ok(poly) => {
              let sqf_list_result : Result[
                (@symnum.BigRational, Array[(@sympolys.Poly, Int)]),
                @sympolys.PolyError,
              ] = try? poly.sqf_list()
              match sqf_list_result {
                Err(error) =>
                  @common.KernelEvalState::Failure(error.to_string())
                Ok((content, factors)) =>
                  finish([
                    poly_field("Poly Form", poly),
                    factor_list_field("Result", content, factors),
                  ])
              }
            }
          }
        }
        "poly_cancel" => {
          let usage = "cancel(num, den)"
          match require_arg_count(args, [2], usage) {
            Err(message) => @common.KernelEvalState::Failure(message)
            Ok(_) =>
              match poly_list_from_exprs(args) {
                Err(error) =>
                  @common.KernelEvalState::Failure(error.to_string())
                Ok((polys, _)) => {
                  let cancel_result : Result[
                    (@sympolys.Poly, @sympolys.Poly),
                    @sympolys.PolyError,
                  ] = try? @sympolys.cancel(polys[0], polys[1])
                  match cancel_result {
                    Err(error) =>
                      @common.KernelEvalState::Failure(error.to_string())
                    Ok((num_s, den_s)) =>
                      finish([
                        poly_field("Numerator", num_s),
                        poly_field("Denominator", den_s),
                        expr_field("Result", quotient_expr(num_s, den_s)),
                      ])
                  }
                }
              }
          }
        }
        "poly_compose" => {
          let usage = "compose(f, g)"
          match require_arg_count(args, [2], usage) {
            Err(message) => @common.KernelEvalState::Failure(message)
            Ok(_) =>
              match poly_list_from_exprs(args) {
                Err(error) =>
                  @common.KernelEvalState::Failure(error.to_string())
                Ok((polys, _)) => {
                  let compose_result : Result[
                    @sympolys.Poly,
                    @sympolys.PolyError,
                  ] = try? @sympolys.compose(polys[0], polys[1])
                  match compose_result {
                    Err(error) =>
                      @common.KernelEvalState::Failure(error.to_string())
                    Ok(result) =>
                      finish([
                        poly_list_field("Inputs", polys),
                        poly_field("Result", result),
                      ])
                  }
                }
              }
          }
        }
        "decompose" => {
          let poly_result : Result[@sympolys.Poly, @sympolys.PolyError] = try? @sympolys.Poly::from_expr_defaults(
            expr,
          )
          match poly_result {
            Err(error) => @common.KernelEvalState::Failure(error.to_string())
            Ok(poly) => {
              let decompose_result : Result[
                Array[@sympolys.Poly],
                @sympolys.PolyError,
              ] = try? @sympolys.decompose(poly)
              match decompose_result {
                Err(error) =>
                  @common.KernelEvalState::Failure(error.to_string())
                Ok(parts) =>
                  finish([
                    poly_field("Poly Form", poly),
                    poly_list_field("Result", parts),
                  ])
              }
            }
          }
        }
        "poly_gcd" => {
          let usage = "gcd(f, g)"
          match require_arg_count(args, [2], usage) {
            Err(message) => @common.KernelEvalState::Failure(message)
            Ok(_) =>
              match poly_list_from_exprs(args) {
                Err(error) =>
                  @common.KernelEvalState::Failure(error.to_string())
                Ok((polys, gens)) => {
                  let gcd_result : Result[@sympolys.Poly, @sympolys.PolyError] = if gens.length() <=
                    1 {
                    try? polys[0].gcd_univar(polys[1])
                  } else {
                    try? polys[0].gcd_multivar(polys[1])
                  }
                  match gcd_result {
                    Err(error) =>
                      @common.KernelEvalState::Failure(error.to_string())
                    Ok(result) =>
                      finish([
                        poly_list_field("Inputs", polys),
                        poly_field("Result", result),
                      ])
                  }
                }
              }
          }
        }
        "poly_discriminant" => {
          let poly_result : Result[@sympolys.Poly, @sympolys.PolyError] = try? @sympolys.Poly::from_expr_defaults(
            expr,
          )
          match poly_result {
            Err(error) => @common.KernelEvalState::Failure(error.to_string())
            Ok(poly) => {
              let discriminant_result : Result[
                @sympolys.FieldElem,
                @sympolys.PolyError,
              ] = try? @sympolys.discriminant(poly)
              match discriminant_result {
                Err(error) =>
                  @common.KernelEvalState::Failure(error.to_string())
                Ok(value) =>
                  finish([
                    poly_field("Poly Form", poly),
                    plain_field("Result", value.to_string()),
                  ])
              }
            }
          }
        }
        "poly_resultant" => {
          let usage = "resultant(f, g)"
          match require_arg_count(args, [2], usage) {
            Err(message) => @common.KernelEvalState::Failure(message)
            Ok(_) => {
              let gens = infer_poly_gens(args)
              let variable = principal_poly_gen(gens)
              let result : Result[@symbit.Expr, @sympolys.PolyError] = try? @sympolys.resultant_expr(
                args[0],
                args[1],
                variable,
                gens~,
                order=@sympolys.TermOrder::Lex,
              )
              match result {
                Err(error) =>
                  @common.KernelEvalState::Failure(error.to_string())
                Ok(value) =>
                  finish([
                    plain_field("Eliminated Variable", variable),
                    expr_field("Result", value),
                  ])
              }
            }
          }
        }
        "poly_groebner" => {
          let usage = "groebner(f1, f2, ..., fn)"
          if args.length() < 2 {
            @common.KernelEvalState::Failure(
              "Expected at least 2 argument(s) in \{usage}.",
            )
          } else {
            let groebner_result : Result[
              Array[@sympolys.Poly],
              @sympolys.PolyError,
            ] = try? @sympolys.groebner_expr(
              args,
              domain=@sympolys.Domain::QQ,
              order=@sympolys.TermOrder::Lex,
            )
            match groebner_result {
              Err(error) => @common.KernelEvalState::Failure(error.to_string())
              Ok(result) => {
                let display_result : Result[
                  Array[@sympolys.Poly],
                  @sympolys.PolyError,
                ] = normalize_groebner_basis_for_display(result)
                match display_result {
                  Err(error) =>
                    @common.KernelEvalState::Failure(error.to_string())
                  Ok(display_basis) =>
                    finish([
                      plain_field("Order", "lex"),
                      poly_list_field("Result", display_basis),
                    ])
                }
              }
            }
          }
        }
        "nt_isprime" =>
          match require_arg_count(args, [1], "isprime(n)") {
            Err(message) => @common.KernelEvalState::Failure(message)
            Ok(_) =>
              match exact_bigint(args[0]) {
                Some(value) =>
                  finish([
                    plain_field("Input", value.to_string()),
                    plain_field(
                      "Result",
                      @symntheory.isprime(value).to_string(),
                    ),
                  ])
                None =>
                  @common.KernelEvalState::Failure(
                    "Expected an exact integer in isprime(n).",
                  )
              }
          }
        "nt_factorint" =>
          match require_arg_count(args, [1], "factorint(n)") {
            Err(message) => @common.KernelEvalState::Failure(message)
            Ok(_) =>
              match exact_bigint(args[0]) {
                Some(value) => {
                  let result = @symntheory.factorint(value)
                  finish([
                    plain_field("Input", value.to_string()),
                    plain_field("Result", factorint_text(result)),
                  ])
                }
                None =>
                  @common.KernelEvalState::Failure(
                    "Expected an exact integer in factorint(n).",
                  )
              }
          }
        "nt_totient" =>
          match require_arg_count(args, [1], "totient(n)") {
            Err(message) => @common.KernelEvalState::Failure(message)
            Ok(_) =>
              match exact_bigint(args[0]) {
                Some(value) =>
                  finish([
                    plain_field("Input", value.to_string()),
                    plain_field(
                      "Result",
                      @symntheory.totient(value).to_string(),
                    ),
                  ])
                None =>
                  @common.KernelEvalState::Failure(
                    "Expected an exact integer in totient(n).",
                  )
              }
          }
        "nt_divisor_sigma" =>
          match
            require_arg_count(
              args,
              [1, 2],
              "divisor_sigma(n) or divisor_sigma(n, k)",
            ) {
            Err(message) => @common.KernelEvalState::Failure(message)
            Ok(_) =>
              match exact_bigint(args[0]) {
                Some(value) => {
                  let k = if args.length() == 2 {
                    match exact_int(args[1]) {
                      Some(power) => power
                      None =>
                        return @common.KernelEvalState::Failure(
                          "Expected an exact integer exponent in divisor_sigma(n, k).",
                        )
                    }
                  } else {
                    1
                  }
                  finish([
                    plain_field("Input", value.to_string()),
                    plain_field("Exponent", k.to_string()),
                    plain_field(
                      "Result",
                      @symntheory.divisor_sigma(value, k~).to_string(),
                    ),
                  ])
                }
                None =>
                  @common.KernelEvalState::Failure(
                    "Expected an exact integer input in divisor_sigma.",
                  )
              }
          }
        "nt_mobius" =>
          match require_arg_count(args, [1], "mobius(n)") {
            Err(message) => @common.KernelEvalState::Failure(message)
            Ok(_) =>
              match exact_bigint(args[0]) {
                Some(value) => {
                  let mobius_result : Result[Int, Error] = try? @symntheory.mobius(
                    value,
                  )
                  match mobius_result {
                    Err(error) =>
                      @common.KernelEvalState::Failure(error.to_string())
                    Ok(result) =>
                      finish([
                        plain_field("Input", value.to_string()),
                        plain_field("Result", result.to_string()),
                      ])
                  }
                }
                None =>
                  @common.KernelEvalState::Failure(
                    "Expected an exact integer in mobius(n).",
                  )
              }
          }
        "nt_primepi" =>
          match require_arg_count(args, [1], "primepi(n)") {
            Err(message) => @common.KernelEvalState::Failure(message)
            Ok(_) =>
              match exact_bigint(args[0]) {
                Some(value) =>
                  finish([
                    plain_field("Input", value.to_string()),
                    plain_field(
                      "Result",
                      @symntheory.primepi(value).to_string(),
                    ),
                  ])
                None =>
                  @common.KernelEvalState::Failure(
                    "Expected an exact integer in primepi(n).",
                  )
              }
          }
        "nt_nextprime" =>
          match require_arg_count(args, [1], "nextprime(n)") {
            Err(message) => @common.KernelEvalState::Failure(message)
            Ok(_) =>
              match exact_bigint(args[0]) {
                Some(value) =>
                  finish([
                    plain_field("Input", value.to_string()),
                    plain_field(
                      "Result",
                      @symntheory.nextprime(value).to_string(),
                    ),
                  ])
                None =>
                  @common.KernelEvalState::Failure(
                    "Expected an exact integer in nextprime(n).",
                  )
              }
          }
        "nt_npartitions" =>
          match require_arg_count(args, [1], "npartitions(n)") {
            Err(message) => @common.KernelEvalState::Failure(message)
            Ok(_) =>
              match exact_int(args[0]) {
                Some(value) if value >= 0 =>
                  finish([
                    plain_field("Input", value.to_string()),
                    plain_field(
                      "Result",
                      @symntheory.npartitions(value).to_string(),
                    ),
                  ])
                Some(_) =>
                  @common.KernelEvalState::Failure(
                    "Expected a non-negative exact integer in npartitions(n).",
                  )
                None =>
                  @common.KernelEvalState::Failure(
                    "Expected an exact integer in npartitions(n).",
                  )
              }
          }
        "msigma" => {
          let usage = "msigma(i)"
          match require_arg_count(args, [1], usage) {
            Err(message) => @common.KernelEvalState::Failure(message)
            Ok(_) =>
              match require_int_args(args, usage) {
                Err(message) => @common.KernelEvalState::Failure(message)
                Ok(items) => {
                  let result : Result[
                    @symphysics.ExplicitMatrix,
                    @symphysics.PhysicsError,
                  ] = try? @symphysics.msigma(items[0])
                  match result {
                    Err(error) =>
                      @common.KernelEvalState::Failure(error.to_string())
                    Ok(matrix) =>
                      finish([
                        plain_field("Indices", integer_arg_list_text(items)),
                        matrix_field("Result", matrix),
                      ])
                  }
                }
              }
          }
        }
        "mgamma" => {
          let usage = "mgamma(mu)"
          match require_arg_count(args, [1], usage) {
            Err(message) => @common.KernelEvalState::Failure(message)
            Ok(_) =>
              match require_int_args(args, usage) {
                Err(message) => @common.KernelEvalState::Failure(message)
                Ok(items) => {
                  let result : Result[
                    @symphysics.ExplicitMatrix,
                    @symphysics.PhysicsError,
                  ] = try? @symphysics.mgamma(items[0])
                  match result {
                    Err(error) =>
                      @common.KernelEvalState::Failure(error.to_string())
                    Ok(matrix) =>
                      finish([
                        plain_field("Indices", integer_arg_list_text(items)),
                        matrix_field("Result", matrix),
                      ])
                  }
                }
              }
          }
        }
        "mdft" => {
          let usage = "mdft(n)"
          match require_arg_count(args, [1], usage) {
            Err(message) => @common.KernelEvalState::Failure(message)
            Ok(_) =>
              match require_int_args(args, usage) {
                Err(message) => @common.KernelEvalState::Failure(message)
                Ok(items) => {
                  let result : Result[
                    @symphysics.ExplicitMatrix,
                    @symphysics.PhysicsError,
                  ] = try? @symphysics.mdft(items[0])
                  match result {
                    Err(error) =>
                      @common.KernelEvalState::Failure(error.to_string())
                    Ok(matrix) =>
                      finish([
                        plain_field("Order", items[0].to_string()),
                        matrix_field("Result", matrix),
                      ])
                  }
                }
              }
          }
        }
        "pat_matrix" => {
          let usage = "pat_matrix(m, dx, dy, dz)"
          match require_arg_count(args, [4], usage) {
            Err(message) => @common.KernelEvalState::Failure(message)
            Ok(_) => {
              let matrix = @symphysics.pat_matrix(
                args[0],
                args[1],
                args[2],
                args[3],
              )
              finish([
                expr_list_field("Arguments", args),
                matrix_field("Result", matrix),
              ])
            }
          }
        }
        "delta" => {
          let usage = "delta(i, j)"
          match require_arg_count(args, [2], usage) {
            Err(message) => @common.KernelEvalState::Failure(message)
            Ok(_) =>
              match require_int_args(args, usage) {
                Err(message) => @common.KernelEvalState::Failure(message)
                Ok(items) =>
                  finish([
                    plain_field("Indices", integer_arg_list_text(items)),
                    plain_field(
                      "Result",
                      @symphysics.delta(items[0], items[1]).to_string(),
                    ),
                  ])
              }
          }
        }
        "epsilon" => {
          let usage = "epsilon(i, j, k)"
          match require_arg_count(args, [3], usage) {
            Err(message) => @common.KernelEvalState::Failure(message)
            Ok(_) =>
              match require_int_args(args, usage) {
                Err(message) => @common.KernelEvalState::Failure(message)
                Ok(items) =>
                  finish([
                    plain_field("Indices", integer_arg_list_text(items)),
                    plain_field(
                      "Result",
                      @symphysics.epsilon(items[0], items[1], items[2]).to_string(),
                    ),
                  ])
              }
          }
        }
        "pauli" => {
          let usage = "pauli(i)"
          match require_arg_count(args, [1], usage) {
            Err(message) => @common.KernelEvalState::Failure(message)
            Ok(_) =>
              match require_int_args(args, usage) {
                Err(message) => @common.KernelEvalState::Failure(message)
                Ok(items) => {
                  let result : Result[@symbit.Expr, @symphysics.PhysicsError] = try? @symphysics.pauli(
                    items[0],
                  )
                  match result {
                    Err(error) =>
                      @common.KernelEvalState::Failure(error.to_string())
                    Ok(value) =>
                      finish([
                        plain_field("Index", items[0].to_string()),
                        expr_field("Result", value),
                      ])
                  }
                }
              }
          }
        }
        "hydrogen_e_nl" => {
          let usage = "hydrogen_e_nl(n) or hydrogen_e_nl(n, Z)"
          match require_arg_count(args, [1, 2], usage) {
            Err(message) => @common.KernelEvalState::Failure(message)
            Ok(_) => {
              let result : Result[@symbit.Expr, @symphysics.PhysicsError] = match
                args {
                [n] => try? @symphysics.hydrogen_e_nl(n)
                [n, z] => try? @symphysics.hydrogen_e_nl(n, z~)
                _ => Err(@symphysics.PhysicsError::ValueError("unreachable"))
              }
              match result {
                Err(error) =>
                  @common.KernelEvalState::Failure(error.to_string())
                Ok(value) =>
                  finish([
                    expr_list_field("Arguments", args),
                    expr_field("Result", value),
                  ])
              }
            }
          }
        }
        "hydrogen_r_nl" => {
          let usage = "hydrogen_r_nl(n, l, r) or hydrogen_r_nl(n, l, r, Z)"
          match require_arg_count(args, [3, 4], usage) {
            Err(message) => @common.KernelEvalState::Failure(message)
            Ok(_) => {
              let value = match args {
                [n, l, r] => @symphysics.hydrogen_r_nl(n, l, r)
                [n, l, r, z] => @symphysics.hydrogen_r_nl(n, l, r, z~)
                _ => expr
              }
              finish([
                expr_list_field("Arguments", args),
                expr_field("Result", value),
              ])
            }
          }
        }
        "hydrogen_y_lm" => {
          let usage = "hydrogen_y_lm(l, m, phi, theta)"
          match require_arg_count(args, [4], usage) {
            Err(message) => @common.KernelEvalState::Failure(message)
            Ok(_) => {
              let value = @symphysics.hydrogen_y_lm(
                args[0],
                args[1],
                args[2],
                args[3],
              )
              finish([
                expr_list_field("Arguments", args),
                expr_field("Result", value),
              ])
            }
          }
        }
        "hydrogen_z_lm" => {
          let usage = "hydrogen_z_lm(l, m, phi, theta)"
          match require_arg_count(args, [4], usage) {
            Err(message) => @common.KernelEvalState::Failure(message)
            Ok(_) => {
              let value = @symphysics.hydrogen_z_lm(
                args[0],
                args[1],
                args[2],
                args[3],
              )
              finish([
                expr_list_field("Arguments", args),
                expr_field("Result", value),
              ])
            }
          }
        }
        "hydrogen_psi_nlm" => {
          let usage = "hydrogen_psi_nlm(n, l, m, r, phi, theta) or hydrogen_psi_nlm(n, l, m, r, phi, theta, Z)"
          match require_arg_count(args, [6, 7], usage) {
            Err(message) => @common.KernelEvalState::Failure(message)
            Ok(_) => {
              let result : Result[@symbit.Expr, @symphysics.PhysicsError] = match
                args {
                [n, l, m, r, phi, theta] =>
                  try? @symphysics.hydrogen_psi_nlm(n, l, m, r, phi, theta)
                [n, l, m, r, phi, theta, z] =>
                  try? @symphysics.hydrogen_psi_nlm(n, l, m, r, phi, theta, z~)
                _ => Err(@symphysics.PhysicsError::ValueError("unreachable"))
              }
              match result {
                Err(error) =>
                  @common.KernelEvalState::Failure(error.to_string())
                Ok(value) =>
                  finish([
                    expr_list_field("Arguments", args),
                    expr_field("Result", value),
                  ])
              }
            }
          }
        }
        "wigner_3j" => {
          let usage = "wigner_3j(j1, j2, j3, m1, m2, m3)"
          match require_arg_count(args, [6], usage) {
            Err(message) => @common.KernelEvalState::Failure(message)
            Ok(_) => {
              let result : Result[@symbit.Expr, @symphysics.PhysicsError] = try? @symphysics.wigner_3j(
                args[0],
                args[1],
                args[2],
                args[3],
                args[4],
                args[5],
              )
              match result {
                Err(error) =>
                  @common.KernelEvalState::Failure(error.to_string())
                Ok(value) =>
                  finish([
                    expr_list_field("Arguments", args),
                    expr_field("Result", value),
                  ])
              }
            }
          }
        }
        "clebsch_gordan" => {
          let usage = "clebsch_gordan(j1, j2, j3, m1, m2, m3)"
          match require_arg_count(args, [6], usage) {
            Err(message) => @common.KernelEvalState::Failure(message)
            Ok(_) => {
              let result : Result[@symbit.Expr, @symphysics.PhysicsError] = try? @symphysics.clebsch_gordan(
                args[0],
                args[1],
                args[2],
                args[3],
                args[4],
                args[5],
              )
              match result {
                Err(error) =>
                  @common.KernelEvalState::Failure(error.to_string())
                Ok(value) =>
                  finish([
                    expr_list_field("Arguments", args),
                    expr_field("Result", value),
                  ])
              }
            }
          }
        }
        "gaunt" => {
          let usage = "gaunt(l1, l2, l3, m1, m2, m3)"
          match require_arg_count(args, [6], usage) {
            Err(message) => @common.KernelEvalState::Failure(message)
            Ok(_) => {
              let result : Result[@symbit.Expr, @symphysics.PhysicsError] = try? @symphysics.gaunt(
                args[0],
                args[1],
                args[2],
                args[3],
                args[4],
                args[5],
              )
              match result {
                Err(error) =>
                  @common.KernelEvalState::Failure(error.to_string())
                Ok(value) =>
                  finish([
                    expr_list_field("Arguments", args),
                    expr_field("Result", value),
                  ])
              }
            }
          }
        }
        "refraction_angle" => {
          let usage = "refraction_angle(theta, n1, n2)"
          match require_arg_count(args, [3], usage) {
            Err(message) => @common.KernelEvalState::Failure(message)
            Ok(_) => {
              let result : Result[@symbit.Expr, @symphysics.PhysicsError] = try? @symphysics.refraction_angle(
                args[0],
                @symphysics.optics_index_arg(args[1]),
                @symphysics.optics_index_arg(args[2]),
              )
              match result {
                Err(error) =>
                  @common.KernelEvalState::Failure(error.to_string())
                Ok(value) =>
                  finish([
                    expr_list_field("Arguments", args),
                    expr_field("Result", value),
                  ])
              }
            }
          }
        }
        "brewster_angle" => {
          let usage = "brewster_angle(n1, n2)"
          match require_arg_count(args, [2], usage) {
            Err(message) => @common.KernelEvalState::Failure(message)
            Ok(_) => {
              let value = @symphysics.brewster_angle(
                @symphysics.optics_index_arg(args[0]),
                @symphysics.optics_index_arg(args[1]),
              )
              finish([
                expr_list_field("Arguments", args),
                expr_field("Result", value),
              ])
            }
          }
        }
        "critical_angle" => {
          let usage = "critical_angle(n1, n2)"
          match require_arg_count(args, [2], usage) {
            Err(message) => @common.KernelEvalState::Failure(message)
            Ok(_) => {
              let result : Result[@symbit.Expr, @symphysics.PhysicsError] = try? @symphysics.critical_angle(
                @symphysics.optics_index_arg(args[0]),
                @symphysics.optics_index_arg(args[1]),
              )
              match result {
                Err(error) =>
                  @common.KernelEvalState::Failure(error.to_string())
                Ok(value) =>
                  finish([
                    expr_list_field("Arguments", args),
                    expr_field("Result", value),
                  ])
              }
            }
          }
        }
        "fresnel_coefficients" => {
          let usage = "fresnel_coefficients(theta, n1, n2)"
          match require_arg_count(args, [3], usage) {
            Err(message) => @common.KernelEvalState::Failure(message)
            Ok(_) => {
              let result : Result[Array[@symbit.Expr], @symphysics.PhysicsError] = try? @symphysics.fresnel_coefficients(
                args[0],
                @symphysics.optics_index_arg(args[1]),
                @symphysics.optics_index_arg(args[2]),
              )
              match result {
                Err(error) =>
                  @common.KernelEvalState::Failure(error.to_string())
                Ok(values) =>
                  finish([
                    expr_list_field("Arguments", args),
                    expr_list_field("Result", values),
                  ])
              }
            }
          }
        }
        "jones_vector" => {
          let usage = "jones_vector(psi, chi)"
          match require_arg_count(args, [2], usage) {
            Err(message) => @common.KernelEvalState::Failure(message)
            Ok(_) => {
              let result : Result[
                @symphysics.ExplicitMatrix,
                @symphysics.PhysicsError,
              ] = try? @symphysics.jones_vector(args[0], args[1])
              match result {
                Err(error) =>
                  @common.KernelEvalState::Failure(error.to_string())
                Ok(matrix) =>
                  finish([
                    expr_list_field("Arguments", args),
                    matrix_field("Result", matrix),
                  ])
              }
            }
          }
        }
        "stokes_vector" => {
          let usage = "stokes_vector(psi, chi) or stokes_vector(psi, chi, p, I0)"
          match require_arg_count(args, [2, 4], usage) {
            Err(message) => @common.KernelEvalState::Failure(message)
            Ok(_) => {
              let result : Result[
                @symphysics.ExplicitMatrix,
                @symphysics.PhysicsError,
              ] = match args {
                [psi, chi] => try? @symphysics.stokes_vector(psi, chi)
                [psi, chi, p, intensity] =>
                  try? @symphysics.stokes_vector(psi, chi, p~, intensity~)
                _ => Err(@symphysics.PhysicsError::ValueError("unreachable"))
              }
              match result {
                Err(error) =>
                  @common.KernelEvalState::Failure(error.to_string())
                Ok(matrix) =>
                  finish([
                    expr_list_field("Arguments", args),
                    matrix_field("Result", matrix),
                  ])
              }
            }
          }
        }
        "free_space" => {
          let usage = "free_space(d)"
          match require_arg_count(args, [1], usage) {
            Err(message) => @common.KernelEvalState::Failure(message)
            Ok(_) => {
              let matrix = @symphysics.free_space(args[0])
              finish([
                expr_field("Distance", args[0]),
                ray_transfer_matrix_field("Result", matrix),
              ])
            }
          }
        }
        "flat_refraction" => {
          let usage = "flat_refraction(n1, n2)"
          match require_arg_count(args, [2], usage) {
            Err(message) => @common.KernelEvalState::Failure(message)
            Ok(_) => {
              let matrix = @symphysics.flat_refraction(args[0], args[1])
              finish([
                expr_list_field("Arguments", args),
                ray_transfer_matrix_field("Result", matrix),
              ])
            }
          }
        }
        "curved_refraction" => {
          let usage = "curved_refraction(R, n1, n2)"
          match require_arg_count(args, [3], usage) {
            Err(message) => @common.KernelEvalState::Failure(message)
            Ok(_) => {
              let matrix = @symphysics.curved_refraction(
                args[0],
                args[1],
                args[2],
              )
              finish([
                expr_list_field("Arguments", args),
                ray_transfer_matrix_field("Result", matrix),
              ])
            }
          }
        }
        "curved_mirror" => {
          let usage = "curved_mirror(R)"
          match require_arg_count(args, [1], usage) {
            Err(message) => @common.KernelEvalState::Failure(message)
            Ok(_) => {
              let matrix = @symphysics.curved_mirror(args[0])
              finish([
                expr_field("Radius", args[0]),
                ray_transfer_matrix_field("Result", matrix),
              ])
            }
          }
        }
        "thin_lens" => {
          let usage = "thin_lens(f)"
          match require_arg_count(args, [1], usage) {
            Err(message) => @common.KernelEvalState::Failure(message)
            Ok(_) => {
              let matrix = @symphysics.thin_lens(args[0])
              finish([
                expr_field("Focal Length", args[0]),
                ray_transfer_matrix_field("Result", matrix),
              ])
            }
          }
        }
        "linear_polarizer" => {
          let usage = "linear_polarizer(theta)"
          match require_arg_count(args, [1], usage) {
            Err(message) => @common.KernelEvalState::Failure(message)
            Ok(_) => {
              let result : Result[
                @symphysics.ExplicitMatrix,
                @symphysics.PhysicsError,
              ] = try? @symphysics.linear_polarizer(theta=args[0])
              match result {
                Err(error) =>
                  @common.KernelEvalState::Failure(error.to_string())
                Ok(matrix) =>
                  finish([
                    expr_field("Angle", args[0]),
                    matrix_field("Result", matrix),
                  ])
              }
            }
          }
        }
        "phase_retarder" => {
          let usage = "phase_retarder(theta, delta)"
          match require_arg_count(args, [2], usage) {
            Err(message) => @common.KernelEvalState::Failure(message)
            Ok(_) => {
              let matrix = @symphysics.phase_retarder(
                theta=args[0],
                delta=args[1],
              )
              finish([
                expr_list_field("Arguments", args),
                matrix_field("Result", matrix),
              ])
            }
          }
        }
        "half_wave_retarder" => {
          let usage = "half_wave_retarder(theta)"
          match require_arg_count(args, [1], usage) {
            Err(message) => @common.KernelEvalState::Failure(message)
            Ok(_) => {
              let matrix = @symphysics.half_wave_retarder(args[0])
              finish([
                expr_field("Angle", args[0]),
                matrix_field("Result", matrix),
              ])
            }
          }
        }
        "quarter_wave_retarder" => {
          let usage = "quarter_wave_retarder(theta)"
          match require_arg_count(args, [1], usage) {
            Err(message) => @common.KernelEvalState::Failure(message)
            Ok(_) => {
              let matrix = @symphysics.quarter_wave_retarder(args[0])
              finish([
                expr_field("Angle", args[0]),
                matrix_field("Result", matrix),
              ])
            }
          }
        }
        "solve" => {
          let symbol = x_symbol()
          let solve_result : Result[
            @symsolvers.SolveResult,
            @symsolvers.SolverError,
          ] = try? @symsolvers.solve(@symsolvers.solve_expr_input(expr), symbols=[
            symbol,
          ])
          match solve_result {
            Err(error) => @common.KernelEvalState::Failure(error.to_string())
            Ok(solved) =>
              finish([
                expr_field("Symbol", symbol),
                plain_field("Result", solve_result_text(solved)),
              ])
          }
        }
        "solveset" => {
          let symbol = x_symbol()
          let solve_result : Result[@symsets.Set, @symsolvers.SolverError] = try? @symsolvers.solveset(
            expr,
            symbol=Some(symbol),
            domain=@symsolvers.complexes,
          )
          match solve_result {
            Err(error) => @common.KernelEvalState::Failure(error.to_string())
            Ok(solved) =>
              finish([
                expr_field("Symbol", symbol),
                plain_field("Domain", "Complexes"),
                plain_field("Result", set_text(solved)),
              ])
          }
        }
        "linsolve" =>
          match require_arg_count(args, [2], "linsolve((eq1, ...), (x, ...))") {
            Err(message) => @common.KernelEvalState::Failure(message)
            Ok(_) => {
              let equations = expr_args(args[0])
              let symbols = expr_args(args[1])
              let solve_result : Result[@symsets.Set, @symsolvers.SolverError] = try? @symsolvers.linsolve(
                @symsolvers.linsolve_equations_input(equations),
                symbols,
              )
              match solve_result {
                Err(error) =>
                  @common.KernelEvalState::Failure(error.to_string())
                Ok(solved) =>
                  finish([
                    expr_list_field("Equations", equations),
                    expr_list_field("Symbols", symbols),
                    plain_field("Result", set_text(solved)),
                  ])
              }
            }
          }
        "nonlinsolve" =>
          match
            require_arg_count(args, [2], "nonlinsolve((eq1, ...), (x, ...))") {
            Err(message) => @common.KernelEvalState::Failure(message)
            Ok(_) => {
              let equations = expr_args(args[0])
              let symbols = expr_args(args[1])
              let solve_result : Result[@symsets.Set, @symsolvers.SolverError] = try? @symsolvers.nonlinsolve(
                equations, symbols,
              )
              match solve_result {
                Err(error) =>
                  @common.KernelEvalState::Failure(error.to_string())
                Ok(solved) =>
                  finish([
                    expr_list_field("Equations", equations),
                    expr_list_field("Symbols", symbols),
                    plain_field("Result", set_text(solved)),
                  ])
              }
            }
          }
        "decompogen" => {
          let symbol = x_symbol()
          let decomp_result : Result[
            Array[@symbit.Expr],
            @symsolvers.SolverError,
          ] = try? @symsolvers.decompogen(expr, symbol)
          match decomp_result {
            Err(error) => @common.KernelEvalState::Failure(error.to_string())
            Ok(parts) =>
              finish([
                expr_field("Symbol", symbol),
                expr_list_field("Result", parts),
              ])
          }
        }
        _ => unknown_function(request.function_id)
      }
    }
  }
}

///|
pub fn evaluate_json(request_json : String) -> String {
  let response = try {
    let decoded : @common.KernelRequest = @json.from_json(
      @json.parse(request_json),
    )
    evaluate_request(decoded)
  } catch {
    error => @common.KernelEvalState::Failure(error.to_string())
  }
  response.to_json().stringify()
}
