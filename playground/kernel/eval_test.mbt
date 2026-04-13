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
    @common.KernelEvalState::Success(payload) =>
      inspect(payload.fields[0].value, content="(A & B) | (A & C)")
  }
  let sat_request = @common.kernel_request(
    "logic_satisfiable",
    "A & ~A",
    test_parser_settings(),
  )
  match evaluate_request(sat_request) {
    @common.KernelEvalState::Failure(message) =>
      fail("logic_satisfiable failed: \{message}")
    @common.KernelEvalState::Success(payload) =>
      inspect(payload.fields[0].value, content="False")
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
test "kernel textplot front door returns ascii plot output" {
  let request = @common.kernel_request(
    "textplot",
    "(sin(x), -4, 4)",
    test_parser_settings(),
  )
  match evaluate_request(request) {
    @common.KernelEvalState::Failure(message) =>
      fail("textplot failed: \{message}")
    @common.KernelEvalState::Success(payload) => {
      inspect(payload.fields.length(), content="1")
      inspect(payload.fields[0].label, content="Result")
      if !payload.fields[0].value.contains("|") {
        fail("expected ascii axis markers in textplot output")
      }
    }
  }
}

///|
test "kernel plot front door returns sampled line payload" {
  let request = @common.kernel_request(
    "plot",
    "(x^3 - 3*x, -4, 4)",
    test_parser_settings(),
  )
  match evaluate_request(request) {
    @common.KernelEvalState::Failure(message) =>
      fail("plot failed: \{message}")
    @common.KernelEvalState::Success(payload) =>
      match payload.fields[0].plot {
        Some(@common.PlotPayload::Line(points)) =>
          if points.length() < 20 {
            fail("expected a sampled line plot payload")
          }
        _ => fail("expected line plot payload")
      }
  }
}

///|
test "kernel plot_parametric front door returns sampled planar payload" {
  let request = @common.kernel_request(
    "plot_parametric",
    "(cos(x), sin(x), 0, 2*pi)",
    test_parser_settings(),
  )
  match evaluate_request(request) {
    @common.KernelEvalState::Failure(message) =>
      fail("plot_parametric failed: \{message}")
    @common.KernelEvalState::Success(payload) =>
      match payload.fields[0].plot {
        Some(@common.PlotPayload::Line(points)) =>
          if points.length() < 20 {
            fail("expected a sampled parametric line payload")
          }
        _ => fail("expected parametric line payload")
      }
  }
}

///|
test "kernel plot_implicit front door returns filled-region payload" {
  let request = @common.kernel_request(
    "plot_implicit",
    "(y > x, -4, 4, -4, 4)",
    test_parser_settings(),
  )
  match evaluate_request(request) {
    @common.KernelEvalState::Failure(message) =>
      fail("plot_implicit failed: \{message}")
    @common.KernelEvalState::Success(payload) =>
      match payload.fields[0].plot {
        Some(@common.PlotPayload::Rects(rects)) =>
          if rects.length() == 0 {
            fail("expected a non-empty implicit fill payload")
          }
        _ => fail("expected implicit fill payload")
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

///|
test "kernel new matrix front doors expose inverse solve rank and charpoly" {
  let inv_request = @common.kernel_request(
    "matrix_inv",
    "((1, 2), (3, 5))",
    test_parser_settings(),
  )
  match evaluate_request(inv_request) {
    @common.KernelEvalState::Failure(message) =>
      fail("matrix_inv failed: \{message}")
    @common.KernelEvalState::Success(payload) => {
      inspect(payload.fields[1].label, content="Result")
      if !payload.fields[1].value.contains("-5") ||
        !payload.fields[1].value.contains("2") ||
        !payload.fields[1].value.contains("3") ||
        !payload.fields[1].value.contains("-1") {
        fail("expected an explicit inverse matrix")
      }
    }
  }
  let solve_request = @common.kernel_request(
    "matrix_solve",
    "(((2, 1), (1, 3)), (1, 2))",
    test_parser_settings(),
  )
  match evaluate_request(solve_request) {
    @common.KernelEvalState::Failure(message) =>
      fail("matrix_solve failed: \{message}")
    @common.KernelEvalState::Success(payload) => {
      inspect(payload.fields[2].label, content="Result")
      if !payload.fields[2].value.contains("1/5") ||
        !payload.fields[2].value.contains("3/5") {
        fail("expected a column-vector linear solve result")
      }
    }
  }
  let rank_request = @common.kernel_request(
    "matrix_rank",
    "((1, 2, 3), (2, 4, 6), (1, 1, 1))",
    test_parser_settings(),
  )
  match evaluate_request(rank_request) {
    @common.KernelEvalState::Failure(message) =>
      fail("matrix_rank failed: \{message}")
    @common.KernelEvalState::Success(payload) =>
      inspect(payload.fields[1].value, content="2")
  }
  let charpoly_request = @common.kernel_request(
    "matrix_charpoly",
    "((1, 2), (3, 4))",
    test_parser_settings(),
  )
  match evaluate_request(charpoly_request) {
    @common.KernelEvalState::Failure(message) =>
      fail("matrix_charpoly failed: \{message}")
    @common.KernelEvalState::Success(payload) => {
      inspect(payload.fields[2].label, content="Result")
      if !payload.fields[2].value.contains("lambda") ||
        !payload.fields[2].value.contains("5") ||
        !payload.fields[2].value.contains("2") {
        fail("expected a characteristic polynomial in lambda")
      }
    }
  }
}

///|
test "kernel new ntheory and transform front doors expose exact results" {
  let primepi_request = @common.kernel_request(
    "nt_primepi",
    "100",
    test_parser_settings(),
  )
  match evaluate_request(primepi_request) {
    @common.KernelEvalState::Failure(message) =>
      fail("nt_primepi failed: \{message}")
    @common.KernelEvalState::Success(payload) =>
      inspect(payload.fields[1].value, content="25")
  }
  let nextprime_request = @common.kernel_request(
    "nt_nextprime",
    "100",
    test_parser_settings(),
  )
  match evaluate_request(nextprime_request) {
    @common.KernelEvalState::Failure(message) =>
      fail("nt_nextprime failed: \{message}")
    @common.KernelEvalState::Success(payload) =>
      inspect(payload.fields[1].value, content="101")
  }
  let npartitions_request = @common.kernel_request(
    "nt_npartitions",
    "12",
    test_parser_settings(),
  )
  match evaluate_request(npartitions_request) {
    @common.KernelEvalState::Failure(message) =>
      fail("nt_npartitions failed: \{message}")
    @common.KernelEvalState::Success(payload) =>
      inspect(payload.fields[1].value, content="77")
  }
  let laplace_request = @common.kernel_request(
    "laplace_transform",
    "1",
    test_parser_settings(),
  )
  match evaluate_request(laplace_request) {
    @common.KernelEvalState::Failure(message) =>
      fail("laplace_transform failed: \{message}")
    @common.KernelEvalState::Success(payload) => {
      inspect(payload.fields[2].label, content="Result")
      if payload.fields[2].value.contains("LaplaceTransform") ||
        !payload.fields[2].value.contains("s") {
        fail("expected a shifted Laplace-domain denominator")
      }
    }
  }
  let inverse_request = @common.kernel_request(
    "inverse_laplace_transform",
    "1/s",
    test_parser_settings(),
  )
  match evaluate_request(inverse_request) {
    @common.KernelEvalState::Failure(message) =>
      fail("inverse_laplace_transform failed: \{message}")
    @common.KernelEvalState::Success(payload) => {
      inspect(payload.fields[2].label, content="Result")
      if payload.fields[2].value.contains("InverseLaplaceTransform") ||
        !payload.fields[2].value.contains("Heaviside(t)") {
        fail("expected a shifted exponential time-domain result")
      }
    }
  }
}

///|
test "kernel new solver front doors expose linear and nonlinear system results" {
  let linsolve_request = @common.kernel_request(
    "linsolve",
    "((x + y - 2, x - y), (x, y))",
    test_parser_settings(),
  )
  match evaluate_request(linsolve_request) {
    @common.KernelEvalState::Failure(message) =>
      fail("linsolve failed: \{message}")
    @common.KernelEvalState::Success(payload) => {
      inspect(payload.fields[2].label, content="Result")
      if !payload.fields[2].value.contains("1") {
        fail("expected a finite linear solution set")
      }
    }
  }
  let nonlinsolve_request = @common.kernel_request(
    "nonlinsolve",
    "((x^2 - 4, y - 1), (x, y))",
    test_parser_settings(),
  )
  match evaluate_request(nonlinsolve_request) {
    @common.KernelEvalState::Failure(message) =>
      fail("nonlinsolve failed: \{message}")
    @common.KernelEvalState::Success(payload) => {
      inspect(payload.fields[2].label, content="Result")
      if !payload.fields[2].value.contains("-2") ||
        !payload.fields[2].value.contains("2") ||
        !payload.fields[2].value.contains("1") {
        fail("expected a finite nonlinear solution set")
      }
    }
  }
}
