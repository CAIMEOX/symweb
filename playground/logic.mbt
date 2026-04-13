///|
fn default_parser_settings() -> ParserSettings {
  {
    caret_as_power: true,
    evaluate: true,
    implicit_multiplication: false,
    implicit_application: false,
    function_exponentiation: false,
    factorial_notation: false,
    convert_equals_signs: false,
  }
}

///|
fn theme_mode_label(mode : ThemeMode) -> String {
  match mode {
    ThemeMode::System => "System"
    ThemeMode::Light => "Light"
    ThemeMode::Dark => "Dark"
  }
}

///|
fn theme_mode_help(mode : ThemeMode) -> String {
  match mode {
    ThemeMode::System => "Follow the browser and operating-system color scheme."
    ThemeMode::Light => "Force the interface into a light theme."
    ThemeMode::Dark => "Force the interface into a dark theme."
  }
}

///|
fn theme_mode_catalog() -> Array[ThemeMode] {
  [ThemeMode::System, ThemeMode::Light, ThemeMode::Dark]
}

///|
fn theme_mode_token(mode : ThemeMode) -> String {
  match mode {
    ThemeMode::System => "system"
    ThemeMode::Light => "light"
    ThemeMode::Dark => "dark"
  }
}

///|
fn parser_toggle_label(toggle : ParserToggle) -> String {
  match toggle {
    ParserToggle::CaretAsPower => "Caret As Power"
    ParserToggle::Evaluate => "Evaluate Constants"
    ParserToggle::ImplicitMultiplication => "Implicit Multiplication"
    ParserToggle::ImplicitApplication => "Implicit Application"
    ParserToggle::FunctionExponentiation => "Function Exponentiation"
    ParserToggle::FactorialNotation => "Factorial Notation"
    ParserToggle::ConvertEqualsSigns => "Convert Equals Signs"
  }
}

///|
fn parser_toggle_help(toggle : ParserToggle) -> String {
  match toggle {
    ParserToggle::CaretAsPower =>
      "Interpret ^ as exponentiation instead of a literal caret."
    ParserToggle::Evaluate => "Fold obvious constants during parsing."
    ParserToggle::ImplicitMultiplication => "Allow input like 2x or x(y + 1)."
    ParserToggle::ImplicitApplication =>
      "Allow input like sin x without parentheses."
    ParserToggle::FunctionExponentiation => "Allow syntax like sin^2(x)."
    ParserToggle::FactorialNotation =>
      "Allow postfix factorial syntax such as n!."
    ParserToggle::ConvertEqualsSigns =>
      "Lower a single = into an equality expression."
  }
}

///|
fn parser_toggle_value(
  settings : ParserSettings,
  toggle : ParserToggle,
) -> Bool {
  match toggle {
    ParserToggle::CaretAsPower => settings.caret_as_power
    ParserToggle::Evaluate => settings.evaluate
    ParserToggle::ImplicitMultiplication => settings.implicit_multiplication
    ParserToggle::ImplicitApplication => settings.implicit_application
    ParserToggle::FunctionExponentiation => settings.function_exponentiation
    ParserToggle::FactorialNotation => settings.factorial_notation
    ParserToggle::ConvertEqualsSigns => settings.convert_equals_signs
  }
}

///|
fn toggle_parser_setting(
  settings : ParserSettings,
  toggle : ParserToggle,
) -> ParserSettings {
  match toggle {
    ParserToggle::CaretAsPower =>
      { ..settings, caret_as_power: !settings.caret_as_power }
    ParserToggle::Evaluate => { ..settings, evaluate: !settings.evaluate }
    ParserToggle::ImplicitMultiplication =>
      { ..settings, implicit_multiplication: !settings.implicit_multiplication }
    ParserToggle::ImplicitApplication =>
      { ..settings, implicit_application: !settings.implicit_application }
    ParserToggle::FunctionExponentiation =>
      { ..settings, function_exponentiation: !settings.function_exponentiation }
    ParserToggle::FactorialNotation =>
      { ..settings, factorial_notation: !settings.factorial_notation }
    ParserToggle::ConvertEqualsSigns =>
      { ..settings, convert_equals_signs: !settings.convert_equals_signs }
  }
}

///|
fn parser_toggle_catalog() -> Array[ParserToggle] {
  [
    ParserToggle::CaretAsPower,
    ParserToggle::Evaluate,
    ParserToggle::ImplicitMultiplication,
    ParserToggle::ImplicitApplication,
    ParserToggle::FunctionExponentiation,
    ParserToggle::FactorialNotation,
    ParserToggle::ConvertEqualsSigns,
  ]
}

///|
fn example_source_or_default(
  function_id : DocFunction,
  example_id : String,
) -> FunctionExample {
  match example_by_id(function_id, example_id) {
    Some(item) => item
    None => default_example(function_id)
  }
}

///|
fn function_runtime_id(function_id : DocFunction) -> String {
  match function_id {
    Simplify => "simplify"
    TrigSimp => "trigsimp"
    RatSimp => "ratsimp"
    Diff => "diff"
    Periodicity => "periodicity"
    Singularities => "singularities"
    Integrate => "integrate"
    LaplaceTransform => "laplace_transform"
    InverseLaplaceTransform => "inverse_laplace_transform"
    SeriesExpand => "series"
    Limit => "limit"
    Residue => "residue"
    AssumeIsInteger => "assume_is_integer"
    AssumeIsReal => "assume_is_real"
    AssumeIsPositive => "assume_is_positive"
    LogicSimplify => "logic_simplify"
    LogicToCnf => "logic_to_cnf"
    LogicToDnf => "logic_to_dnf"
    LogicSatisfiable => "logic_satisfiable"
    SetInterval => "set_interval"
    SetFinite => "set_finite"
    SetContains => "set_contains"
    Summation => "summation"
    Product => "product"
    Rationalize => "rationalize"
    DiscreteFFT => "discrete_fft"
    DiscreteIFFT => "discrete_ifft"
    DiscreteFWHT => "discrete_fwht"
    DiscreteMobius => "discrete_mobius"
    MatrixConstruct => "matrix_construct"
    MatrixEye => "matrix_eye"
    MatrixZeros => "matrix_zeros"
    MatrixOnes => "matrix_ones"
    MatrixDet => "matrix_det"
    MatrixTrace => "matrix_trace"
    MatrixInv => "matrix_inv"
    MatrixRank => "matrix_rank"
    MatrixCharpoly => "matrix_charpoly"
    MatrixSolve => "matrix_solve"
    TermsGcd => "terms_gcd"
    PolyFactor => "poly_factor"
    PolyFactorList => "poly_factor_list"
    PolySqfPart => "poly_sqf_part"
    PolySqfList => "poly_sqf_list"
    PolyCancel => "poly_cancel"
    PolyCompose => "poly_compose"
    Decompose => "decompose"
    PolyGcd => "poly_gcd"
    PolyDiscriminant => "poly_discriminant"
    PolyResultant => "poly_resultant"
    PolyGroebner => "poly_groebner"
    NtIsPrime => "nt_isprime"
    NtFactorInt => "nt_factorint"
    NtTotient => "nt_totient"
    NtDivisorSigma => "nt_divisor_sigma"
    NtMobius => "nt_mobius"
    NtPrimePi => "nt_primepi"
    NtNextPrime => "nt_nextprime"
    NtNPartitions => "nt_npartitions"
    PhysMsigma => "msigma"
    PhysMgamma => "mgamma"
    PhysMdft => "mdft"
    PhysPatMatrix => "pat_matrix"
    PhysDelta => "delta"
    PhysEpsilon => "epsilon"
    PhysPauli => "pauli"
    PhysHydrogenENl => "hydrogen_e_nl"
    PhysHydrogenRNl => "hydrogen_r_nl"
    PhysHydrogenYlm => "hydrogen_y_lm"
    PhysHydrogenZlm => "hydrogen_z_lm"
    PhysHydrogenPsiNlm => "hydrogen_psi_nlm"
    PhysWigner3j => "wigner_3j"
    PhysClebschGordan => "clebsch_gordan"
    PhysGaunt => "gaunt"
    PhysRefractionAngle => "refraction_angle"
    PhysBrewsterAngle => "brewster_angle"
    PhysCriticalAngle => "critical_angle"
    PhysFresnelCoefficients => "fresnel_coefficients"
    PhysJonesVector => "jones_vector"
    PhysStokesVector => "stokes_vector"
    PhysFreeSpace => "free_space"
    PhysFlatRefraction => "flat_refraction"
    PhysCurvedRefraction => "curved_refraction"
    PhysCurvedMirror => "curved_mirror"
    PhysThinLens => "thin_lens"
    PhysLinearPolarizer => "linear_polarizer"
    PhysPhaseRetarder => "phase_retarder"
    PhysHalfWaveRetarder => "half_wave_retarder"
    PhysQuarterWaveRetarder => "quarter_wave_retarder"
    Solve => "solve"
    SolveSet => "solveset"
    LinSolve => "linsolve"
    NonLinSolve => "nonlinsolve"
    Decompogen => "decompogen"
  }
}

///|
fn function_headline(function_id : DocFunction) -> String {
  match function_id {
    Simplify => "General Simplification"
    TrigSimp => "Trigonometric Simplification"
    RatSimp => "Rational Simplification"
    Diff => "Differential Operator"
    Periodicity => "Periodicity Analysis"
    Singularities => "Singularity Analysis"
    Integrate => "Indefinite Integration"
    LaplaceTransform => "Laplace Transform"
    InverseLaplaceTransform => "Inverse Laplace Transform"
    SeriesExpand => "Series Expansion"
    Limit => "Limit"
    Residue => "Residue"
    AssumeIsInteger => "Integer Predicate"
    AssumeIsReal => "Real Predicate"
    AssumeIsPositive => "Positivity Predicate"
    LogicSimplify => "Boolean Simplification"
    LogicToCnf => "Conjunctive Normal Form"
    LogicToDnf => "Disjunctive Normal Form"
    LogicSatisfiable => "Satisfiability"
    SetInterval => "Closed Interval"
    SetFinite => "Finite Set"
    SetContains => "Set Membership"
    Summation => "Finite Summation"
    Product => "Finite Product"
    Rationalize => "Rational Reconstruction"
    DiscreteFFT => "Discrete Fourier Transform"
    DiscreteIFFT => "Inverse Discrete Fourier Transform"
    DiscreteFWHT => "Fast Walsh-Hadamard Transform"
    DiscreteMobius => "Möbius Transform"
    MatrixConstruct => "Dense Matrix Construction"
    MatrixEye => "Identity Matrix"
    MatrixZeros => "Zero Matrix"
    MatrixOnes => "All-Ones Matrix"
    MatrixDet => "Determinant"
    MatrixTrace => "Trace"
    MatrixInv => "Matrix Inverse"
    MatrixRank => "Matrix Rank"
    MatrixCharpoly => "Characteristic Polynomial"
    MatrixSolve => "Linear System Solve"
    TermsGcd => "Polynomial Term GCD"
    PolyFactor => "Polynomial Factorization"
    PolyFactorList => "Polynomial Factor List"
    PolySqfPart => "Square-Free Part"
    PolySqfList => "Square-Free Factor List"
    PolyCancel => "Polynomial Rational Cancellation"
    PolyCompose => "Polynomial Composition"
    Decompose => "Polynomial Decomposition"
    PolyGcd => "Polynomial Greatest Common Divisor"
    PolyDiscriminant => "Polynomial Discriminant"
    PolyResultant => "Polynomial Resultant"
    PolyGroebner => "Groebner Basis"
    NtIsPrime => "Primality Test"
    NtFactorInt => "Integer Factorization"
    NtTotient => "Euler Totient"
    NtDivisorSigma => "Divisor Sigma"
    NtMobius => "Mobius Function"
    NtPrimePi => "Prime-Counting Function"
    NtNextPrime => "Next Prime"
    NtNPartitions => "Partition Number"
    PhysMsigma => "Pauli Matrix"
    PhysMgamma => "Gamma Matrix"
    PhysMdft => "Discrete Fourier Transform Matrix"
    PhysPatMatrix => "Parallel Axis Theorem Matrix"
    PhysDelta => "Kronecker Delta"
    PhysEpsilon => "Levi-Civita Symbol"
    PhysPauli => "Pauli Algebra Generator"
    PhysHydrogenENl => "Hydrogenic Energy Level"
    PhysHydrogenRNl => "Hydrogen Radial Wavefunction"
    PhysHydrogenYlm => "Complex Spherical Harmonic"
    PhysHydrogenZlm => "Real Spherical Harmonic"
    PhysHydrogenPsiNlm => "Hydrogen Orbital Wavefunction"
    PhysWigner3j => "Wigner 3j Symbol"
    PhysClebschGordan => "Clebsch-Gordan Coefficient"
    PhysGaunt => "Gaunt Coefficient"
    PhysRefractionAngle => "Refraction Angle"
    PhysBrewsterAngle => "Brewster Angle"
    PhysCriticalAngle => "Critical Angle"
    PhysFresnelCoefficients => "Fresnel Coefficients"
    PhysJonesVector => "Jones Vector"
    PhysStokesVector => "Stokes Vector"
    PhysFreeSpace => "Free-Space ABCD Matrix"
    PhysFlatRefraction => "Flat-Refraction ABCD Matrix"
    PhysCurvedRefraction => "Curved-Refraction ABCD Matrix"
    PhysCurvedMirror => "Curved-Mirror ABCD Matrix"
    PhysThinLens => "Thin-Lens ABCD Matrix"
    PhysLinearPolarizer => "Linear Polarizer Jones Matrix"
    PhysPhaseRetarder => "Phase-Retarder Jones Matrix"
    PhysHalfWaveRetarder => "Half-Wave Plate Matrix"
    PhysQuarterWaveRetarder => "Quarter-Wave Plate Matrix"
    Solve => "Equation Solving"
    SolveSet => "Set-Valued Solving"
    LinSolve => "Linear System Solving"
    NonLinSolve => "Nonlinear System Solving"
    Decompogen => "Functional Decomposition"
  }
}

///|
fn result_field(label : String, value : String) -> ResultField {
  { label, value, latex: None }
}

///|
fn result_field_latex(
  label : String,
  value : String,
  latex : String?,
) -> ResultField {
  { label, value, latex }
}

///|
fn kernel_request(
  source : String,
  parser : ParserSettings,
  function_id : DocFunction,
) -> @common.KernelRequest {
  @common.kernel_request(
    function_runtime_id(function_id),
    source,
    @common.parser_settings(
      parser.caret_as_power,
      parser.evaluate,
      parser.implicit_multiplication,
      parser.implicit_application,
      parser.function_exponentiation,
      parser.factorial_notation,
      parser.convert_equals_signs,
    ),
  )
}

///|
fn kernel_loading_message() -> String {
  "The wasm compute kernel is still loading."
}

///|
fn debounce_ms() -> Int {
  420
}

///|
fn kernel_poll_ms() -> Int {
  120
}

///|
#cfg(target="js")
extern "js" fn apply_theme_mode(token : String) =
  #| function(token) {
  #|   if (typeof document === "undefined" || !document.documentElement) {
  #|     return;
  #|   }
  #|   document.documentElement.setAttribute("data-theme", token);
  #| }

///|
#cfg(not(target="js"))
fn apply_theme_mode(_token : String) -> Unit {
  ()
}

///|
#cfg(target="js")
extern "js" fn wasm_kernel_status() -> String =
  #| function() {
  #|   if (typeof globalThis.__symwebKernel !== "undefined" && globalThis.__symwebKernel !== null) {
  #|     return "ready";
  #|   }
  #|   if (typeof globalThis.__symwebKernelError === "string" && globalThis.__symwebKernelError.length > 0) {
  #|     return "error:" + globalThis.__symwebKernelError;
  #|   }
  #|   return "loading";
  #| }

///|
#cfg(target="js")
extern "js" fn wasm_kernel_run_eval_json(request_json : String) -> String =
  #| function(requestJson) {
  #|   const kernel = globalThis.__symwebKernel;
  #|   if (!kernel || typeof kernel.runEvalJson !== "function") {
  #|     return "";
  #|   }
  #|   return kernel.runEvalJson(requestJson);
  #| }

///|
#cfg(not(target="js"))
fn wasm_kernel_status() -> String {
  "unavailable"
}

///|
#cfg(not(target="js"))
fn wasm_kernel_run_eval_json(_request_json : String) -> String {
  ""
}

///|
fn decode_kernel_response(response_json : String) -> @common.KernelEvalState {
  if response_json.trim() == "" {
    return @common.kernel_failure(kernel_loading_message())
  }
  try {
    let parsed = @json.parse(response_json)
    @json.from_json(parsed)
  } catch {
    error => @common.KernelEvalState::Failure(error.to_string())
  }
}

///|
fn kernel_field_to_result_field(field : @common.ResultField) -> ResultField {
  { label: field.label, value: field.value, latex: field.latex }
}

///|
fn evaluate_source(
  source : String,
  parser : ParserSettings,
  function_id : DocFunction,
) -> EvalState {
  let trimmed = source.trim()
  if trimmed == "" {
    return EvalState::Failure(
      "Enter a symbolic expression before running the reference example.",
    )
  }
  match wasm_kernel_status() {
    "ready" => {
      let request = kernel_request(trimmed.to_string(), parser, function_id)
      let response = decode_kernel_response(
        wasm_kernel_run_eval_json(request.to_json().stringify()),
      )
      match response {
        @common.KernelEvalState::Failure(message) => EvalState::Failure(message)
        @common.KernelEvalState::Success(payload) => {
          let mut result_only : ResultField? = None
          for field in payload.fields {
            if field.label == "Result" {
              result_only = Some(kernel_field_to_result_field(field))
              break
            }
          }
          let visible_fields = [
            result_field_latex(
              "Parsed Expression",
              payload.parsed_expression,
              payload.parsed_latex,
            ),
            result_field("Structural Form", payload.structural_form),
          ]
          if result_only is Some(field) {
            visible_fields.push(field)
          }
          EvalState::Success({
            headline: function_headline(function_id),
            summary: "",
            fields: visible_fields,
          })
        }
      }
    }
    "loading" => EvalState::Failure(kernel_loading_message())
    status if status.has_prefix("error:") =>
      EvalState::Failure(status[6:].to_string())
    _ => EvalState::Failure("The wasm compute kernel is unavailable.")
  }
}

///|
fn recompute_model(model : DocModel) -> DocModel {
  {
    ..model,
    result: evaluate_source(
      model.draft_source,
      model.parser,
      model.active_function,
    ),
    dirty: false,
  }
}

///|
fn model_for_function(
  model : DocModel,
  function_id : DocFunction,
  example? : FunctionExample? = None,
) -> DocModel {
  let selected_example = match example {
    Some(item) => item
    None => default_example(function_id)
  }
  recompute_model({
    ..model,
    active_package: function_doc(function_id).package_id,
    active_function: function_id,
    active_example: selected_example.id,
    draft_source: selected_example.source,
    draft_revision: model.draft_revision + 1,
  })
}

///|
fn default_model() -> DocModel {
  let pkg = default_package()
  let function_id = default_function(pkg)
  let example = default_example(function_id)
  let theme_mode = ThemeMode::System
  apply_theme_mode(theme_mode_token(theme_mode))
  recompute_model({
    active_package: pkg,
    active_function: function_id,
    expanded_packages: [pkg],
    active_example: example.id,
    draft_source: example.source,
    parser: default_parser_settings(),
    theme_mode,
    show_structural_form: true,
    result: EvalState::Failure(kernel_loading_message()),
    dirty: false,
    draft_revision: 0,
    settings_open: false,
  })
}
