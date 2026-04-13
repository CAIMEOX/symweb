///|
pub(all) struct ParserSettings {
  caret_as_power : Bool
  evaluate : Bool
  implicit_multiplication : Bool
  implicit_application : Bool
  function_exponentiation : Bool
  factorial_notation : Bool
  convert_equals_signs : Bool
} derive(Eq, ToJson, FromJson)

///|
pub fn parser_settings(
  caret_as_power : Bool,
  evaluate : Bool,
  implicit_multiplication : Bool,
  implicit_application : Bool,
  function_exponentiation : Bool,
  factorial_notation : Bool,
  convert_equals_signs : Bool,
) -> ParserSettings {
  {
    caret_as_power,
    evaluate,
    implicit_multiplication,
    implicit_application,
    function_exponentiation,
    factorial_notation,
    convert_equals_signs,
  }
}

///|
pub(all) struct PlotPoint {
  x : Double
  y : Double
} derive(Eq, ToJson, FromJson)

///|
pub fn plot_point(x : Double, y : Double) -> PlotPoint {
  { x, y }
}

///|
pub(all) struct PlotRect {
  x_start : Double
  x_end : Double
  y_start : Double
  y_end : Double
} derive(Eq, ToJson, FromJson)

///|
pub fn plot_rect(
  x_start : Double,
  x_end : Double,
  y_start : Double,
  y_end : Double,
) -> PlotRect {
  { x_start, x_end, y_start, y_end }
}

///|
pub(all) enum PlotPayload {
  Line(Array[PlotPoint])
  Scatter(Array[PlotPoint])
  Rects(Array[PlotRect])
} derive(Eq, ToJson, FromJson)

///|
pub(all) struct ResultField {
  label : String
  value : String
  latex : String?
  plot : PlotPayload?
} derive(Eq, ToJson, FromJson)

///|
pub fn result_field(
  label : String,
  value : String,
  latex? : String? = None,
  plot? : PlotPayload? = None,
) -> ResultField {
  { label, value, latex, plot }
}

///|
pub(all) struct KernelRequest {
  function_id : String
  source : String
  parser : ParserSettings
} derive(Eq, ToJson, FromJson)

///|
pub fn kernel_request(
  function_id : String,
  source : String,
  parser : ParserSettings,
) -> KernelRequest {
  { function_id, source, parser }
}

///|
pub(all) struct KernelSuccess {
  parsed_expression : String
  parsed_latex : String?
  structural_form : String
  fields : Array[ResultField]
} derive(Eq, ToJson, FromJson)

///|
pub fn kernel_success_payload(
  parsed_expression : String,
  parsed_latex : String?,
  structural_form : String,
  fields : Array[ResultField],
) -> KernelSuccess {
  { parsed_expression, parsed_latex, structural_form, fields }
}

///|
pub(all) enum KernelEvalState {
  Success(KernelSuccess)
  Failure(String)
} derive(Eq, ToJson, FromJson)

///|
pub fn kernel_success(
  parsed_expression : String,
  parsed_latex : String?,
  structural_form : String,
  fields : Array[ResultField],
) -> KernelEvalState {
  Success(
    kernel_success_payload(
      parsed_expression, parsed_latex, structural_form, fields,
    ),
  )
}

///|
pub fn kernel_failure(message : String) -> KernelEvalState {
  Failure(message)
}
