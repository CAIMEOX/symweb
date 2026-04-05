///|
fn test_parser_settings() -> @common.ParserSettings {
  @common.parser_settings(true, true, false, false, false, false, false)
}

///|
test "kernel factor_list returns a visible Result field" {
  let request = @common.kernel_request(
    "poly_factor_list",
    "2*x^2 - 4*x + 2",
    test_parser_settings(),
  )
  match evaluate_request(request) {
    @common.KernelEvalState::Failure(message) =>
      fail("factor_list failed: \{message}")
    @common.KernelEvalState::Success(payload) => {
      inspect(payload.fields.length(), content="2")
      inspect(payload.fields[1].label, content="Result")
      inspect(payload.fields[1].value, content="(2, [(x - 1, 2)])")
    }
  }
}

///|
test "kernel groebner lifts integer inputs to a field domain" {
  let request = @common.kernel_request(
    "poly_groebner",
    "(x^2 + y^2 - 1, x - y)",
    test_parser_settings(),
  )
  match evaluate_request(request) {
    @common.KernelEvalState::Failure(message) =>
      fail("groebner failed: \{message}")
    @common.KernelEvalState::Success(payload) => {
      inspect(payload.fields.length(), content="2")
      inspect(payload.fields[1].label, content="Result")
      if !payload.fields[1].value.contains("2*y**2 - 1") {
        fail("expected integer-normalized Groebner basis")
      }
      if !payload.fields[1].value.contains("x") ||
        !payload.fields[1].value.contains("y") {
        fail("expected symbolic generators in Groebner basis")
      }
    }
  }
}

///|
test "kernel series exposes a truncated expansion result" {
  let request = @common.kernel_request(
    "series",
    "log(1 + x)",
    test_parser_settings(),
  )
  match evaluate_request(request) {
    @common.KernelEvalState::Failure(message) =>
      fail("series failed: \{message}")
    @common.KernelEvalState::Success(payload) => {
      inspect(payload.fields.length(), content="3")
      inspect(payload.fields[2].label, content="Result")
      if !payload.fields[2].value.contains("x") ||
        !payload.fields[2].value.contains("O(") {
        fail("expected a truncated series expansion")
      }
    }
  }
}

///|
test "kernel factorint exposes arithmetic factor maps" {
  let request = @common.kernel_request(
    "nt_factorint",
    "360",
    test_parser_settings(),
  )
  match evaluate_request(request) {
    @common.KernelEvalState::Failure(message) =>
      fail("factorint failed: \{message}")
    @common.KernelEvalState::Success(payload) => {
      inspect(payload.fields.length(), content="2")
      inspect(payload.fields[1].label, content="Result")
      inspect(payload.fields[1].value, content="{2: 3, 3: 2, 5: 1}")
    }
  }
}
