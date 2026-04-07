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

///|
test "kernel set front doors expose interval construction and membership" {
  let request = @common.kernel_request(
    "set_contains",
    "(2, 0, 3)",
    test_parser_settings(),
  )
  match evaluate_request(request) {
    @common.KernelEvalState::Failure(message) =>
      fail("set_contains failed: \{message}")
    @common.KernelEvalState::Success(payload) => {
      inspect(payload.fields.length(), content="3")
      inspect(payload.fields[1].label, content="Set")
      inspect(payload.fields[1].value, content="Interval(0, 3)")
      inspect(payload.fields[2].label, content="Result")
      inspect(payload.fields[2].value, content="True")
    }
  }
}

///|
test "kernel assumption predicates expose three-valued semantic answers" {
  let real_request = @common.kernel_request(
    "assume_is_real",
    "I",
    test_parser_settings(),
  )
  match evaluate_request(real_request) {
    @common.KernelEvalState::Failure(message) =>
      fail("assume_is_real failed: \{message}")
    @common.KernelEvalState::Success(payload) => {
      inspect(payload.fields.length(), content="2")
      inspect(payload.fields[1].label, content="Result")
      inspect(payload.fields[1].value, content="False")
    }
  }
  let positive_request = @common.kernel_request(
    "assume_is_positive",
    "x^2",
    test_parser_settings(),
  )
  match evaluate_request(positive_request) {
    @common.KernelEvalState::Failure(message) =>
      fail("assume_is_positive failed: \{message}")
    @common.KernelEvalState::Success(payload) => {
      inspect(payload.fields[1].label, content="Result")
      inspect(payload.fields[1].value, content="Unknown")
    }
  }
}

///|
test "kernel logic front doors parse infix boolean syntax and simplify it" {
  let simplify_request = @common.kernel_request(
    "logic_simplify",
    "A & True | A & False",
    test_parser_settings(),
  )
  match evaluate_request(simplify_request) {
    @common.KernelEvalState::Failure(message) =>
      fail("logic_simplify failed: \{message}")
    @common.KernelEvalState::Success(payload) => {
      inspect(payload.parsed_expression, content="A")
      inspect(payload.fields.length(), content="1")
      inspect(payload.fields[0].label, content="Result")
      inspect(payload.fields[0].value, content="A")
    }
  }
  let cnf_request = @common.kernel_request(
    "logic_to_cnf",
    "A | (B & C)",
    test_parser_settings(),
  )
  match evaluate_request(cnf_request) {
    @common.KernelEvalState::Failure(message) =>
      fail("logic_to_cnf failed: \{message}")
    @common.KernelEvalState::Success(payload) => {
      inspect(payload.fields[0].label, content="Result")
      inspect(payload.fields[0].value, content="(A | B) & (A | C)")
    }
  }
}

///|
test "kernel concrete front doors evaluate finite products and sums" {
  let product_request = @common.kernel_request(
    "product",
    "(k, 1, 5)",
    test_parser_settings(),
  )
  match evaluate_request(product_request) {
    @common.KernelEvalState::Failure(message) =>
      fail("product failed: \{message}")
    @common.KernelEvalState::Success(payload) => {
      inspect(payload.fields[2].label, content="Result")
      inspect(payload.fields[2].value, content="120")
    }
  }
  let summation_request = @common.kernel_request(
    "summation",
    "(k^2, 1, 3)",
    test_parser_settings(),
  )
  match evaluate_request(summation_request) {
    @common.KernelEvalState::Failure(message) =>
      fail("summation failed: \{message}")
    @common.KernelEvalState::Success(payload) => {
      inspect(payload.fields[2].label, content="Result")
      if !payload.fields[2].value.contains("3**2") {
        fail("expected explicit finite summation result terms")
      }
    }
  }
}

///|
test "kernel logic satisfiable and dnf front doors expose boolean results" {
  let dnf_request = @common.kernel_request(
    "logic_to_dnf",
    "A & (B | C)",
    test_parser_settings(),
  )
  match evaluate_request(dnf_request) {
    @common.KernelEvalState::Failure(message) =>
      fail("logic_to_dnf failed: \{message}")
    @common.KernelEvalState::Success(payload) => {
      inspect(payload.fields[0].value, content="(A & B) | (A & C)")
    }
  }
  let sat_request = @common.kernel_request(
    "logic_satisfiable",
    "A & ~A",
    test_parser_settings(),
  )
  match evaluate_request(sat_request) {
    @common.KernelEvalState::Failure(message) =>
      fail("logic_satisfiable failed: \{message}")
    @common.KernelEvalState::Success(payload) => {
      inspect(payload.fields[0].value, content="False")
    }
  }
}

///|
test "kernel matrix front doors expose dense constructors and invariants" {
  let construct_request = @common.kernel_request(
    "matrix_construct",
    "((1, x), (x, 1))",
    test_parser_settings(),
  )
  match evaluate_request(construct_request) {
    @common.KernelEvalState::Failure(message) =>
      fail("matrix_construct failed: \{message}")
    @common.KernelEvalState::Success(payload) => {
      inspect(payload.fields.length(), content="2")
      inspect(payload.fields[0].label, content="Shape")
      inspect(payload.fields[0].value, content="(2, 2)")
      inspect(payload.fields[1].label, content="Result")
      inspect(payload.fields[1].value, content="Matrix([[1, x], [x, 1]])")
    }
  }
  let det_request = @common.kernel_request(
    "matrix_det",
    "((1, 2), (3, 4))",
    test_parser_settings(),
  )
  match evaluate_request(det_request) {
    @common.KernelEvalState::Failure(message) =>
      fail("matrix_det failed: \{message}")
    @common.KernelEvalState::Success(payload) => {
      inspect(payload.fields[1].label, content="Result")
      inspect(payload.fields[1].value, content="-2")
    }
  }
  let eye_request = @common.kernel_request(
    "matrix_eye",
    "3",
    test_parser_settings(),
  )
  match evaluate_request(eye_request) {
    @common.KernelEvalState::Failure(message) =>
      fail("matrix_eye failed: \{message}")
    @common.KernelEvalState::Success(payload) => {
      inspect(payload.fields[0].value, content="(3, 3)")
      if !payload.fields[1].value.contains("Matrix([[1, 0, 0]") {
        fail("expected an explicit 3x3 identity matrix")
      }
    }
  }
}

///|
test "kernel discrete transforms expose fft and mobius front doors" {
  let fft_request = @common.kernel_request(
    "discrete_fft",
    "(1, 2, 3, 4)",
    test_parser_settings(),
  )
  match evaluate_request(fft_request) {
    @common.KernelEvalState::Failure(message) => fail("fft failed: \{message}")
    @common.KernelEvalState::Success(payload) => {
      inspect(payload.fields[1].label, content="Result")
      if !payload.fields[1].value.contains("I") ||
        !payload.fields[1].value.contains("10") {
        fail("expected complex-valued FFT output")
      }
    }
  }
  let mobius_request = @common.kernel_request(
    "discrete_mobius",
    "(1, 2, 3, 4)",
    test_parser_settings(),
  )
  match evaluate_request(mobius_request) {
    @common.KernelEvalState::Failure(message) =>
      fail("mobius_transform failed: \{message}")
    @common.KernelEvalState::Success(payload) => {
      inspect(payload.fields[1].label, content="Result")
      inspect(payload.fields[1].value, content="[1, 3, 4, 10]")
    }
  }
}
