///|
fn package_doc(id : DocPackage) -> PackageDoc {
  match id {
    DocPackage::SymSimplify =>
      {
        id,
        label: "symsimplify",
        overview: "Simplification is organized as a front-door module. The examples below mirror the way SymPy documents broad simplification first, then narrower rewrite families.",
        architecture: "Choose a function, read the reference note, then run the exact expression shown in the example block. The runner is intentionally narrow: one expression in, one normalized result out.",
        functions: [
          DocFunction::Simplify,
          DocFunction::TrigSimp,
          DocFunction::RatSimp,
        ],
      }
    DocPackage::SymCalculus =>
      {
        id,
        label: "symcalculus",
        overview: "This section follows the SymPy calculus split between differential operators and local analytic queries such as periodicity and singularity detection.",
        architecture: "Every function in this package keeps one principal variable, x, unless the example text states otherwise. That keeps the page close to a literate notebook rather than a generic REPL.",
        functions: [
          DocFunction::Diff,
          DocFunction::Periodicity,
          DocFunction::Singularities,
        ],
      }
    DocPackage::SymIntegrals =>
      {
        id,
        label: "symintegrals",
        overview: "Integration is presented as a compact reference pane instead of a theorem catalogue: a single front-door entry point, explicit limits, and readable output.",
        architecture: "The page uses indefinite integration with respect to x, matching the most common SymPy manual examples and keeping the examples stable inside the browser runner.",
        functions: [DocFunction::Integrate],
      }
    DocPackage::SymSeries =>
      {
        id,
        label: "symseries",
        overview: "Series and limit computations are exposed through the same front doors readers usually reach for first: local expansion, limiting value, and residue extraction.",
        architecture: "The browser fixes the expansion variable to x and the base point to 0. That keeps the input surface small while still exercising the real series engine.",
        functions: [
          DocFunction::SeriesExpand,
          DocFunction::Limit,
          DocFunction::Residue,
        ],
      }
    DocPackage::SymSets =>
      {
        id,
        label: "symsets",
        overview: "Set-theoretic output is most useful when it stays concrete. This section focuses on intervals, finite sets, and membership queries, which are the core readable front doors in symbolic workflows.",
        architecture: "Examples deliberately use tuple-shaped input instead of custom syntax. Interval constructors interpret (left, right) as a closed interval, finite-set examples reinterpret the tuple items as elements, and membership checks keep the base set fixed and explicit.",
        functions: [
          DocFunction::SetInterval,
          DocFunction::SetFinite,
          DocFunction::SetContains,
        ],
      }
    DocPackage::SymConcrete =>
      {
        id,
        label: "symconcrete",
        overview: "Concrete mathematics is exposed through executable finite sums, finite products, and exact-rational recovery. These are the front doors most readers use before diving into recurrence or Gosper-style internals.",
        architecture: "The browser fixes the summation and product symbol to k. Tuple inputs are interpreted as (term, lower, upper), which keeps the interface narrow while still exercising the real finite-sum and finite-product code paths.",
        functions: [
          DocFunction::Summation,
          DocFunction::Product,
          DocFunction::Rationalize,
        ],
      }
    DocPackage::SymDiscrete =>
      {
        id,
        label: "symdiscrete",
        overview: "Discrete transforms are presented as small exact sequences rather than opaque numeric buffers. The page keeps the inputs tuple-based so FFT-style algorithms remain inspectable in symbolic form.",
        architecture: "Every discrete front door reads a tuple as a sequence. The transforms here are chosen because they are short, compositional, and visibly different in output shape: Fourier, inverse Fourier, Walsh-Hadamard, and Möbius.",
        functions: [
          DocFunction::DiscreteFFT,
          DocFunction::DiscreteIFFT,
          DocFunction::DiscreteFWHT,
          DocFunction::DiscreteMobius,
        ],
      }
    DocPackage::SymPolys =>
      {
        id,
        label: "sympolys",
        overview: "The polynomial layer is shown through structure-revealing operators rather than raw domain objects. This mirrors the way SymPy's public documentation introduces poly tools through transformations on expressions.",
        architecture: "Examples are lowered to Poly internally and rendered back to expressions, so the browser page stays readable while still exercising the actual polynomial engine.",
        functions: [
          DocFunction::TermsGcd,
          DocFunction::PolyFactor,
          DocFunction::PolyFactorList,
          DocFunction::PolySqfPart,
          DocFunction::PolySqfList,
          DocFunction::PolyCancel,
          DocFunction::PolyCompose,
          DocFunction::Decompose,
          DocFunction::PolyGcd,
          DocFunction::PolyDiscriminant,
          DocFunction::PolyResultant,
          DocFunction::PolyGroebner,
        ],
      }
    DocPackage::SymNTheory =>
      {
        id,
        label: "symntheory",
        overview: "Elementary number theory is presented through exact integer front doors: primality, factorization, divisor sums, and multiplicative arithmetic functions.",
        architecture: "These pages intentionally accept only exact integers or short integer tuples. That keeps the browser interface predictable and matches the arithmetic nature of the underlying algorithms.",
        functions: [
          DocFunction::NtIsPrime,
          DocFunction::NtFactorInt,
          DocFunction::NtTotient,
          DocFunction::NtDivisorSigma,
          DocFunction::NtMobius,
        ],
      }
    DocPackage::SymPhysics =>
      {
        id,
        label: "symphysics",
        overview: "This section is organized the way the physics reference is usually read: small thematic clusters such as matrices, Pauli algebra, hydrogen formulas, Wigner coefficients, and elementary optics, each exposed through executable front-door functions.",
        architecture: "Physics examples often take several arguments, so the editor accepts tuple-shaped inputs like (pi/6, 1, 3/2) whenever a function needs more than one parameter. The function cards below keep the submodule ordering explicit so the page reads like a compact reference manual rather than a loose sandbox.",
        functions: [
          DocFunction::PhysMsigma,
          DocFunction::PhysMgamma,
          DocFunction::PhysMdft,
          DocFunction::PhysPatMatrix,
          DocFunction::PhysDelta,
          DocFunction::PhysEpsilon,
          DocFunction::PhysPauli,
          DocFunction::PhysHydrogenENl,
          DocFunction::PhysHydrogenRNl,
          DocFunction::PhysHydrogenYlm,
          DocFunction::PhysHydrogenZlm,
          DocFunction::PhysHydrogenPsiNlm,
          DocFunction::PhysWigner3j,
          DocFunction::PhysClebschGordan,
          DocFunction::PhysGaunt,
          DocFunction::PhysRefractionAngle,
          DocFunction::PhysBrewsterAngle,
          DocFunction::PhysCriticalAngle,
          DocFunction::PhysFresnelCoefficients,
          DocFunction::PhysJonesVector,
          DocFunction::PhysStokesVector,
          DocFunction::PhysFreeSpace,
          DocFunction::PhysFlatRefraction,
          DocFunction::PhysCurvedRefraction,
          DocFunction::PhysCurvedMirror,
          DocFunction::PhysThinLens,
          DocFunction::PhysLinearPolarizer,
          DocFunction::PhysPhaseRetarder,
          DocFunction::PhysHalfWaveRetarder,
          DocFunction::PhysQuarterWaveRetarder,
        ],
      }
    DocPackage::SymSolvers =>
      {
        id,
        label: "symsolvers",
        overview: "The solver reference is arranged the same way SymPy front doors are usually read: direct equation solving, set-valued solving, and expression decomposition as separate entry points.",
        architecture: "For solver examples the principal symbol is x. That keeps the examples short while still showing the shape of lists, sets, and functional decompositions returned by the real solver layer.",
        functions: [
          DocFunction::Solve,
          DocFunction::SolveSet,
          DocFunction::Decompogen,
        ],
      }
  }
}

///|
fn package_catalog() -> Array[PackageDoc] {
  [
    package_doc(DocPackage::SymSimplify),
    package_doc(DocPackage::SymCalculus),
    package_doc(DocPackage::SymIntegrals),
    package_doc(DocPackage::SymSeries),
    package_doc(DocPackage::SymSets),
    package_doc(DocPackage::SymConcrete),
    package_doc(DocPackage::SymDiscrete),
    package_doc(DocPackage::SymPolys),
    package_doc(DocPackage::SymNTheory),
    package_doc(DocPackage::SymPhysics),
    package_doc(DocPackage::SymSolvers),
  ]
}

///|
fn function_doc(id : DocFunction) -> FunctionDoc {
  match id {
    DocFunction::Simplify =>
      {
        id,
        package_id: DocPackage::SymSimplify,
        label: "simplify",
        module_path: "CAIMEOX/symbit",
        signature: "simplify(expr: Expr) -> Expr",
        summary: "Run the broad simplification dispatcher over a single symbolic expression.",
        narrative: "This is the most general entry point in the page. It corresponds to the wide, heuristic simplification layer that SymPy users typically start with before moving to narrower passes.",
        interpretation: "The runner parses one expression and sends it straight into Symbit's simplify pipeline. The output is shown both as a parsed form and as the final simplified expression.",
        examples: [
          {
            id: "simplify_cancel",
            label: "Cancel a removable factor",
            description: "A minimal front-door case that should collapse to 1.",
            source: "(x + 1) * (x + 1)^(-1)",
          },
          {
            id: "simplify_nested",
            label: "Normalize an additive rational expression",
            description: "A more algebraic example closer to documentation prose.",
            source: "(x^2 - 1)/(x - 1) + y - y",
          },
        ],
      }
    DocFunction::TrigSimp =>
      {
        id,
        package_id: DocPackage::SymSimplify,
        label: "trigsimp",
        module_path: "CAIMEOX/symbit",
        signature: "trigsimp(expr: Expr) -> Expr",
        summary: "Simplify an expression by applying trigonometric identities and rewrites.",
        narrative: "SymPy documents trigonometric simplification as a distinct pass because its rewrite space is narrower and more predictable than general simplify. The same distinction is kept here.",
        interpretation: "Use this when the structure is visibly trigonometric and you want a specialized result rather than a large general-purpose rewrite sweep.",
        examples: [
          {
            id: "trigsimp_identity",
            label: "Pythagorean identity",
            description: "The canonical trigonometric simplification example.",
            source: "sin(x)^2 + cos(x)^2",
          },
          {
            id: "trigsimp_phase",
            label: "Mixed sine and cosine terms",
            description: "A slightly denser example that still stays local.",
            source: "sin(x)^2 - cos(x)^2 + 2*cos(x)^2",
          },
        ],
      }
    DocFunction::RatSimp =>
      {
        id,
        package_id: DocPackage::SymSimplify,
        label: "ratsimp",
        module_path: "CAIMEOX/symbit",
        signature: "ratsimp(expr: Expr) -> Expr",
        summary: "Normalize a rational expression into a tighter numerator and denominator form.",
        narrative: "In SymPy, ratsimp is the deliberate front door for rational normalization. It is narrower than simplify and often better when the structure is obviously fractional.",
        interpretation: "The page keeps the example set univariate or lightly multivariate so the output remains readable inside a documentation-style layout.",
        examples: [
          {
            id: "ratsimp_basic",
            label: "Cancel a rational function",
            description: "A standard removable-factor example.",
            source: "(x^2 - 1)/(x - 1)",
          },
          {
            id: "ratsimp_sum",
            label: "Combine rational addends",
            description: "Shows denominator unification in the front-door API.",
            source: "1/(x + 1) + 1/(x - 1)",
          },
        ],
      }
    DocFunction::Diff =>
      {
        id,
        package_id: DocPackage::SymCalculus,
        label: "diff",
        module_path: "CAIMEOX/symbit/symcalculus",
        signature: "diff(expr: Expr, wrt: Symbol) -> Expr",
        summary: "Differentiate an expression with respect to the principal symbol x.",
        narrative: "The browser view deliberately fixes the variable to x, matching the dominant presentation style in SymPy examples and keeping the runner compact.",
        interpretation: "You edit only the expression. The surrounding reference note tells you the differentiation variable, so the page reads like a literate derivation notebook.",
        examples: [
          {
            id: "diff_product",
            label: "Product and chain rule",
            description: "A compact composition example.",
            source: "exp(x) * sin(x)",
          },
          {
            id: "diff_power",
            label: "Polynomial derivative",
            description: "Useful when scanning the output shape quickly.",
            source: "x^4 + 3*x^2 + 1",
          },
        ],
      }
    DocFunction::Periodicity =>
      {
        id,
        package_id: DocPackage::SymCalculus,
        label: "periodicity",
        module_path: "CAIMEOX/symbit/symcalculus",
        signature: "periodicity(expr: Expr, wrt: Symbol) -> Expr?",
        summary: "Estimate the fundamental period of an expression in x when one exists.",
        narrative: "SymPy treats periodicity as a calculus utility rather than a generic simplifier. The page keeps the same reading model: one expression, one variable, one local analytic answer.",
        interpretation: "When no finite period is found, the result panel says so explicitly instead of collapsing to an empty field.",
        examples: [
          {
            id: "periodicity_trig",
            label: "Simple trigonometric period",
            description: "A baseline periodic example.",
            source: "sin(2*x) + cos(2*x)",
          },
          {
            id: "periodicity_none",
            label: "No finite period",
            description: "Shows the non-periodic branch in the UI.",
            source: "exp(x)",
          },
        ],
      }
    DocFunction::Singularities =>
      {
        id,
        package_id: DocPackage::SymCalculus,
        label: "singularities",
        module_path: "CAIMEOX/symbit/symcalculus",
        signature: "singularities(expr: Expr, wrt: Symbol) -> Set",
        summary: "Compute singular locations of an expression with respect to x.",
        narrative: "This mirrors the SymPy calculus reference pattern: local analytic inspection on a single symbol, surfaced as a lightweight utility rather than a full theorem prover.",
        interpretation: "The output is printed directly as a symbolic object so it stays comparable to the textual style used in technical documentation.",
        examples: [
          {
            id: "singularities_rational",
            label: "Rational poles",
            description: "A denominator-factor example with two simple poles.",
            source: "1/(x^2 + 3*x + 2)",
          },
          {
            id: "singularities_log",
            label: "Logarithmic singular point",
            description: "A branch-sensitive scalar example.",
            source: "log(x)",
          },
        ],
      }
    DocFunction::Integrate =>
      {
        id,
        package_id: DocPackage::SymIntegrals,
        label: "integrate",
        module_path: "CAIMEOX/symbit/symintegrals",
        signature: "integrate(expr: Expr, limits: Array[Expr] = [x]) -> Expr",
        summary: "Integrate an expression indefinitely with respect to x.",
        narrative: "The page uses the same front-door naming as SymPy. Instead of exposing the entire transform stack, the browser focuses on the single indefinite integral path most readers expect first.",
        interpretation: "Examples are chosen so the result comes back as a closed symbolic expression and fits into a technical note layout.",
        examples: [
          {
            id: "integrate_exp",
            label: "Exponential antiderivative",
            description: "A standard single-pass integral.",
            source: "exp(2*x)",
          },
          {
            id: "integrate_trig",
            label: "Trigonometric antiderivative",
            description: "A short example with a visible chain factor.",
            source: "sin(3*x)",
          },
        ],
      }
    DocFunction::SeriesExpand =>
      {
        id,
        package_id: DocPackage::SymSeries,
        label: "series",
        module_path: "CAIMEOX/symbit/symseries",
        signature: "series(expr: Expr, x: Symbol = x, x0: Expr = 0, n: Int = 6) -> Expr",
        summary: "Expand an expression into a truncated series around x = 0.",
        narrative: "This front door keeps to the most common local-analysis pattern: one expression, one variable, one base point, and a fixed truncation order suitable for a compact browser result panel.",
        interpretation: "Enter one expression in x. The page expands at x = 0 and shows the truncated symbolic series directly.",
        examples: [
          {
            id: "series_exp_sin",
            label: "Expand a mixed transcendental expression",
            description: "A standard local expansion around the origin.",
            source: "exp(x) * sin(x)",
          },
          {
            id: "series_log",
            label: "Expand a logarithmic perturbation",
            description: "A series with alternating rational coefficients.",
            source: "log(1 + x)",
          },
        ],
      }
    DocFunction::Limit =>
      {
        id,
        package_id: DocPackage::SymSeries,
        label: "limit",
        module_path: "CAIMEOX/symbit/symseries",
        signature: "limit(expr: Expr, x: Symbol = x, x0: Expr = 0, dir: String = \"+\") -> Expr",
        summary: "Compute the right-hand limit of an expression as x approaches 0.",
        narrative: "The page chooses a fixed local limit point so the examples read like short notebook cells instead of a general-purpose wizard for arbitrary approaches.",
        interpretation: "Enter one expression in x. The runner evaluates the limit as x tends to 0 from the positive side.",
        examples: [
          {
            id: "limit_sine_ratio",
            label: "Classical trigonometric limit",
            description: "A baseline removable-singularity example.",
            source: "sin(x)/x",
          },
          {
            id: "limit_exp_shift",
            label: "Exponential difference quotient",
            description: "A first-order local growth example.",
            source: "(exp(x) - 1)/x",
          },
        ],
      }
    DocFunction::Residue =>
      {
        id,
        package_id: DocPackage::SymSeries,
        label: "residue",
        module_path: "CAIMEOX/symbit/symseries",
        signature: "residue(expr: Expr, x: Symbol = x, x0: Expr = 0) -> Expr",
        summary: "Extract the residue coefficient at x = 0.",
        narrative: "Residues expose the coefficient of (x - x0)^(-1) in a Laurent expansion. The browser uses x0 = 0 to keep the examples compact and visually comparable.",
        interpretation: "Enter one meromorphic expression in x. The result is the symbolic residue at the origin.",
        examples: [
          {
            id: "residue_simple_pole",
            label: "Simple pole at the origin",
            description: "The residue can be read off after a short local rewrite.",
            source: "1/(x*(x + 1))",
          },
          {
            id: "residue_exp",
            label: "Exponential numerator over a simple pole",
            description: "A residue with a nontrivial analytic numerator.",
            source: "exp(x)/x",
          },
        ],
      }
    DocFunction::SetInterval =>
      {
        id,
        package_id: DocPackage::SymSets,
        label: "interval",
        module_path: "CAIMEOX/symbit/symsets",
        signature: "interval(left: Expr, right: Expr) -> Set",
        summary: "Construct a closed interval from two symbolic endpoints.",
        narrative: "An interval is the smallest set constructor that still shows the symbolic set layer in action. It is the usual first step before unions, intersections, and solving over domains.",
        interpretation: "The browser interprets the input tuple as (left, right) and returns the closed interval [left, right].",
        examples: [
          {
            id: "set_interval_numeric",
            label: "Numeric interval",
            description: "A compact closed interval with integer endpoints.",
            source: "(0, 3)",
          },
          {
            id: "set_interval_symbolic",
            label: "Symbolic interval",
            description: "Shows that endpoints stay symbolic and unevaluated.",
            source: "(-a, a + 1)",
          },
        ],
      }
    DocFunction::SetFinite =>
      {
        id,
        package_id: DocPackage::SymSets,
        label: "finite_set",
        module_path: "CAIMEOX/symbit/symsets",
        signature: "finite_set(items: Array[Expr]) -> Set",
        summary: "Build a finite set from the tuple items in the editor input.",
        narrative: "Finite sets are the cleanest bridge between ordinary symbolic expressions and the set domain. They preserve exact expressions while still displaying set semantics.",
        interpretation: "Every tuple component becomes one element of the resulting finite set.",
        examples: [
          {
            id: "set_finite_symbols",
            label: "Mixed symbolic elements",
            description: "Construct a finite set from symbols and arithmetic expressions.",
            source: "(x, 1, y + 1)",
          },
          {
            id: "set_finite_numbers",
            label: "Numeric finite set",
            description: "A discrete set of exact integer elements.",
            source: "(1, 2, 5, 8)",
          },
        ],
      }
    DocFunction::SetContains =>
      {
        id,
        package_id: DocPackage::SymSets,
        label: "contains",
        module_path: "CAIMEOX/symbit/symsets",
        signature: "contains(value: Expr, interval: Interval) -> SetBool",
        summary: "Test whether a value lies in the closed interval defined by the remaining tuple entries.",
        narrative: "Membership tests are the place where set construction starts to matter computationally. They expose the tri-valued symbolic answer space instead of collapsing everything to booleans.",
        interpretation: "The browser interprets the input tuple as (value, left, right) and checks value ∈ [left, right].",
        examples: [
          {
            id: "set_contains_true",
            label: "Value inside interval",
            description: "A direct membership query that should evaluate to True.",
            source: "(2, 0, 3)",
          },
          {
            id: "set_contains_symbolic",
            label: "Symbolic membership",
            description: "Leaves the answer symbolic when the comparison cannot be decided.",
            source: "(x, 0, 1)",
          },
        ],
      }
    DocFunction::Summation =>
      {
        id,
        package_id: DocPackage::SymConcrete,
        label: "summation",
        module_path: "CAIMEOX/symbit/symconcrete",
        signature: "summation(term: Expr, lower: Expr, upper: Expr) -> Expr",
        summary: "Evaluate a finite sum with respect to the fixed summation index k.",
        narrative: "This is the standard concrete-math front door: write a term, a lower bound, and an upper bound, then ask for the exact symbolic sum.",
        interpretation: "The tuple input is read as (term, lower, upper), and the runner binds the summation variable to k.",
        examples: [
          {
            id: "summation_polynomial",
            label: "Polynomial finite sum",
            description: "A textbook finite sum with symbolic upper limit.",
            source: "(k^2, 1, n)",
          },
          {
            id: "summation_numeric",
            label: "Numeric finite sum",
            description: "A finite arithmetic sum with exact integer bounds.",
            source: "(2*k + 1, 0, 5)",
          },
        ],
      }
    DocFunction::Product =>
      {
        id,
        package_id: DocPackage::SymConcrete,
        label: "product",
        module_path: "CAIMEOX/symbit/symconcrete",
        signature: "product(term: Expr, lower: Expr, upper: Expr) -> Expr",
        summary: "Evaluate a finite product with respect to the fixed product index k.",
        narrative: "Products are the multiplicative counterpart of summation. Keeping the index fixed to k lets the page show exact product evaluation without adding extra control syntax.",
        interpretation: "The tuple input is read as (term, lower, upper), and the runner computes the finite product over k.",
        examples: [
          {
            id: "product_factorial",
            label: "Factorial-style product",
            description: "A finite product over consecutive integers.",
            source: "(k, 1, 5)",
          },
          {
            id: "product_shifted",
            label: "Shifted linear factors",
            description: "A product of shifted factors that stays symbolic.",
            source: "(k + x, 1, 3)",
          },
        ],
      }
    DocFunction::Rationalize =>
      {
        id,
        package_id: DocPackage::SymConcrete,
        label: "rationalize",
        module_path: "CAIMEOX/symbit/symconcrete",
        signature: "rationalize(expr: Expr) -> Expr",
        summary: "Recover an exact rational expression from a decimal or floating input.",
        narrative: "Rational reconstruction is useful when a numeric approximation is clearly meant to stand for an exact rational value. It is a small front door, but it shows the exact arithmetic layer directly.",
        interpretation: "The page sends one expression into the rationalization routine and shows the exact recovered result when it is found.",
        examples: [
          {
            id: "rationalize_decimal",
            label: "Finite decimal",
            description: "A decimal with a clean rational reconstruction.",
            source: "0.125",
          },
          {
            id: "rationalize_repeat",
            label: "Simple repeating decimal",
            description: "A decimal that should collapse to a small rational number.",
            source: "0.3",
          },
        ],
      }
    DocFunction::DiscreteFFT =>
      {
        id,
        package_id: DocPackage::SymDiscrete,
        label: "fft",
        module_path: "CAIMEOX/symbit/symdiscrete",
        signature: "fft(seq: Array[Expr]) -> Array[Expr]",
        summary: "Compute the discrete Fourier transform of a symbolic sequence.",
        narrative: "The FFT examples stay short enough to read entry-by-entry. That keeps the transform visible as a symbolic change of basis rather than a hidden numeric kernel.",
        interpretation: "The tuple input is interpreted as the full sequence to transform.",
        examples: [
          {
            id: "fft_basic",
            label: "Length-four transform",
            description: "A standard four-point exact FFT.",
            source: "(1, 2, 3, 4)",
          },
          {
            id: "fft_symbolic",
            label: "Symbolic sequence",
            description: "Shows how the transform distributes over symbolic terms.",
            source: "(1, x, x^2, x^3)",
          },
        ],
      }
    DocFunction::DiscreteIFFT =>
      {
        id,
        package_id: DocPackage::SymDiscrete,
        label: "ifft",
        module_path: "CAIMEOX/symbit/symdiscrete",
        signature: "ifft(seq: Array[Expr]) -> Array[Expr]",
        summary: "Invert a discrete Fourier transform back to the original sequence.",
        narrative: "Inverse FFT examples are useful because they show the exact normalization convention of the transform layer.",
        interpretation: "The tuple input is interpreted as Fourier-domain coefficients, and the runner reconstructs the time-domain sequence.",
        examples: [
          {
            id: "ifft_basic",
            label: "Inverse of the standard four-point FFT",
            description: "This tuple inverts back to (1, 2, 3, 4).",
            source: "(10, -2 + 2*I, -2, -2 - 2*I)",
          },
        ],
      }
    DocFunction::DiscreteFWHT =>
      {
        id,
        package_id: DocPackage::SymDiscrete,
        label: "fwht",
        module_path: "CAIMEOX/symbit/symdiscrete",
        signature: "fwht(seq: Array[Expr]) -> Array[Expr]",
        summary: "Compute the fast Walsh-Hadamard transform of a symbolic sequence.",
        narrative: "The Walsh-Hadamard transform is structurally different from the Fourier transform but uses the same tuple-shaped input surface, making it a good comparative front door.",
        interpretation: "The tuple input is interpreted as the full sequence to transform.",
        examples: [
          {
            id: "fwht_basic",
            label: "Length-four Walsh-Hadamard transform",
            description: "A compact example with exact integer coefficients.",
            source: "(1, 2, 3, 4)",
          },
        ],
      }
    DocFunction::DiscreteMobius =>
      {
        id,
        package_id: DocPackage::SymDiscrete,
        label: "mobius_transform",
        module_path: "CAIMEOX/symbit/symdiscrete",
        signature: "mobius_transform(seq: Array[Expr]) -> Array[Expr]",
        summary: "Apply the subset Möbius transform to a short exact sequence.",
        narrative: "This transform belongs to the combinatorial side of the discrete package. It is valuable here because the output pattern is visibly different from FFT-style transforms while using the same tuple input format.",
        interpretation: "The tuple input is interpreted as the sequence indexed by subsets in binary order.",
        examples: [
          {
            id: "mobius_basic",
            label: "Subset Möbius transform",
            description: "A small exact sequence with a readable transformed output.",
            source: "(1, 2, 3, 4)",
          },
        ],
      }
    DocFunction::TermsGcd =>
      {
        id,
        package_id: DocPackage::SymPolys,
        label: "terms_gcd",
        module_path: "CAIMEOX/symbit/sympolys",
        signature: "terms_gcd(poly: Poly) -> Poly",
        summary: "Factor out the greatest common term content from a polynomial expression.",
        narrative: "SymPy presents term GCD extraction as a structure-revealing poly tool. The same reading model works well in a browser: parse an expression, lower it to Poly, then render the reduced form back to algebraic notation.",
        interpretation: "This demo stays expression-first. Internally it uses the polynomial engine, but the result is shown as a rewritten expression so the page remains approachable.",
        examples: [
          {
            id: "terms_gcd_xy",
            label: "Extract a shared monomial",
            description: "The common x*y factor should come out immediately.",
            source: "x^3*y + x^2*y^2",
          },
          {
            id: "terms_gcd_shift",
            label: "Factor content from a shifted polynomial",
            description: "A univariate example closer to textbook notation.",
            source: "x^4 + x^3",
          },
        ],
      }
    DocFunction::PolyFactor =>
      {
        id,
        package_id: DocPackage::SymPolys,
        label: "factor",
        module_path: "CAIMEOX/symbit/sympolys",
        signature: "factor(poly: Poly) -> Expr",
        summary: "Reconstruct a polynomial as a product of irreducible factors.",
        narrative: "This front door keeps the output in expression form so the factorization reads like ordinary algebra instead of raw internal tuples.",
        interpretation: "Enter one polynomial expression. The browser lowers it to Poly, factors it, then rebuilds the multiplicative expression.",
        examples: [
          {
            id: "poly_factor_quartic",
            label: "Factor a quartic difference",
            description: "A direct factorization into lower-degree pieces.",
            source: "x^4 - 1",
          },
          {
            id: "poly_factor_bivariate",
            label: "Factor a bivariate product",
            description: "A multivariate factorization that stays readable.",
            source: "x^2*y - y",
          },
        ],
      }
    DocFunction::PolyFactorList =>
      {
        id,
        package_id: DocPackage::SymPolys,
        label: "factor_list",
        module_path: "CAIMEOX/symbit/sympolys",
        signature: "factor_list(poly: Poly) -> (Rational, Array[(Poly, Int)])",
        summary: "Return the separated content and irreducible factor list of a polynomial.",
        narrative: "This is the structured factorization interface: scalar content is split from monic factors and multiplicities.",
        interpretation: "Enter one polynomial expression. The result shows both the content and the factor list rather than only the reconstructed product.",
        examples: [
          {
            id: "poly_factor_list_content",
            label: "Content and repeated factors",
            description: "Shows multiplicity and scalar content separately.",
            source: "2*x^2 - 4*x + 2",
          },
          {
            id: "poly_factor_list_cubic",
            label: "Distinct linear factors",
            description: "A cubic with three rational roots.",
            source: "x^3 - x",
          },
        ],
      }
    DocFunction::PolySqfPart =>
      {
        id,
        package_id: DocPackage::SymPolys,
        label: "sqf_part",
        module_path: "CAIMEOX/symbit/sympolys",
        signature: "sqf_part(poly: Poly) -> Poly",
        summary: "Drop repeated irreducible factors and keep only the square-free part.",
        narrative: "Square-free reduction is a standard preprocessing step for factorization and root isolation.",
        interpretation: "Enter one univariate polynomial expression. The output removes multiplicity while preserving the distinct roots.",
        examples: [
          {
            id: "poly_sqf_part_repeat",
            label: "Remove repeated linear factors",
            description: "A product with one repeated factor.",
            source: "(x - 1)^3 * (x + 2)^2",
          },
          {
            id: "poly_sqf_part_dense",
            label: "Square-free part of an expanded polynomial",
            description: "The same operation in dense expanded form.",
            source: "x^5 + x^4 - 5*x^3 - x^2 + 8*x - 4",
          },
        ],
      }
    DocFunction::PolySqfList =>
      {
        id,
        package_id: DocPackage::SymPolys,
        label: "sqf_list",
        module_path: "CAIMEOX/symbit/sympolys",
        signature: "sqf_list(poly: Poly) -> (Rational, Array[(Poly, Int)])",
        summary: "Return square-free factors together with their multiplicities.",
        narrative: "This is the multiplicity-aware companion to sqf_part, keeping the repeated-factor exponents explicit.",
        interpretation: "Enter one univariate polynomial expression. The output exposes the square-free decomposition as structured data.",
        examples: [
          {
            id: "poly_sqf_list_repeat",
            label: "Square-free decomposition",
            description: "Shows repeated roots as separate multiplicities.",
            source: "(x - 1)^3 * (x + 2)^2",
          },
          {
            id: "poly_sqf_list_scaled",
            label: "Scaled square-free list",
            description: "Includes non-unit scalar content.",
            source: "3*(x - 1)^2*(x + 1)",
          },
        ],
      }
    DocFunction::PolyCancel =>
      {
        id,
        package_id: DocPackage::SymPolys,
        label: "cancel",
        module_path: "CAIMEOX/symbit/sympolys",
        signature: "cancel(num: Poly, den: Poly) -> (Poly, Poly)",
        summary: "Cancel common polynomial factors between a numerator and denominator.",
        narrative: "This is the polynomial-level analogue of rational cancellation before the result is turned back into an expression.",
        interpretation: "Enter a tuple (numerator, denominator). The browser returns the reduced numerator, denominator, and the reconstructed quotient.",
        examples: [
          {
            id: "poly_cancel_basic",
            label: "Cancel a shared linear factor",
            description: "The common factor x - 1 should disappear.",
            source: "(x^2 - 1, x - 1)",
          },
          {
            id: "poly_cancel_multivar",
            label: "Cancel a multivariate factor",
            description: "A bivariate exact divisibility case.",
            source: "(x^2*y - y, x - 1)",
          },
        ],
      }
    DocFunction::PolyCompose =>
      {
        id,
        package_id: DocPackage::SymPolys,
        label: "compose",
        module_path: "CAIMEOX/symbit/sympolys",
        signature: "compose(f: Poly, g: Poly) -> Poly",
        summary: "Compose two univariate polynomials as f(g(x)).",
        narrative: "Composition is the constructive counterpart to decomposition and is useful for checking decomposition chains.",
        interpretation: "Enter a tuple (f, g). The result is the composed polynomial in the same principal generator.",
        examples: [
          {
            id: "poly_compose_shift_square",
            label: "Compose a square with a shift",
            description: "A compact univariate composition.",
            source: "(x^2 + 1, x + 1)",
          },
          {
            id: "poly_compose_nested",
            label: "Compose a cubic outer polynomial",
            description: "A slightly denser composition example.",
            source: "(x^3 - x, x^2 + 1)",
          },
        ],
      }
    DocFunction::Decompose =>
      {
        id,
        package_id: DocPackage::SymPolys,
        label: "decompose",
        module_path: "CAIMEOX/symbit/sympolys",
        signature: "decompose(poly: Poly) -> Array[Poly]",
        summary: "Decompose a polynomial into nested polynomial components when possible.",
        narrative: "This follows the same structural view SymPy uses in its polytools documentation: you are not just simplifying a polynomial, you are exposing its compositional layers.",
        interpretation: "Examples are kept single-variable so each decomposition chain reads like a short literate derivation rather than a raw algebra dump.",
        examples: [
          {
            id: "decompose_square",
            label: "Nested square and shift",
            description: "A small composition chain with visible layers.",
            source: "(x^2 + 1)^2",
          },
          {
            id: "decompose_quartic",
            label: "Quartic with cubic shift",
            description: "A denser polynomial composition example.",
            source: "x^4 + 2*x^3 - x - 1",
          },
        ],
      }
    DocFunction::PolyGcd =>
      {
        id,
        package_id: DocPackage::SymPolys,
        label: "gcd",
        module_path: "CAIMEOX/symbit/sympolys",
        signature: "gcd(f: Poly, g: Poly) -> Poly",
        summary: "Compute the greatest common divisor of two polynomials.",
        narrative: "For univariate inputs this follows the Euclidean polynomial gcd path; for multivariate inputs it uses the multivariate compatibility route exposed by sympolys.",
        interpretation: "Enter a tuple (f, g). The browser lowers both expressions to a shared polynomial context before computing the gcd.",
        examples: [
          {
            id: "poly_gcd_univar",
            label: "Univariate gcd",
            description: "A standard common-factor example.",
            source: "(x^3 - x, x^2 - 1)",
          },
          {
            id: "poly_gcd_multivar",
            label: "Multivariate gcd",
            description: "A common monomial-times-binomial factor.",
            source: "(x^2*y - y, x*y - y)",
          },
        ],
      }
    DocFunction::PolyDiscriminant =>
      {
        id,
        package_id: DocPackage::SymPolys,
        label: "discriminant",
        module_path: "CAIMEOX/symbit/sympolys",
        signature: "discriminant(poly: Poly) -> FieldElem",
        summary: "Compute the discriminant of a polynomial.",
        narrative: "The discriminant vanishes exactly when the polynomial has a repeated root over an algebraic closure, so it is a compact singularity detector for polynomial roots.",
        interpretation: "Enter one polynomial expression. The output is the scalar discriminant of that polynomial.",
        examples: [
          {
            id: "poly_discriminant_quadratic",
            label: "Quadratic discriminant",
            description: "A familiar baseline case.",
            source: "x^2 - 4*x + 1",
          },
          {
            id: "poly_discriminant_repeat",
            label: "Repeated-root discriminant",
            description: "This case should return zero.",
            source: "(x - 1)^2",
          },
        ],
      }
    DocFunction::PolyResultant =>
      {
        id,
        package_id: DocPackage::SymPolys,
        label: "resultant",
        module_path: "CAIMEOX/symbit/sympolys",
        signature: "resultant(f: Poly, g: Poly, wrt: Symbol = x) -> Expr",
        summary: "Eliminate the principal variable from a pair of polynomials.",
        narrative: "The resultant is the determinant-style elimination invariant that vanishes exactly when two polynomials share a common root in the eliminated variable.",
        interpretation: "Enter a tuple (f, g). The browser eliminates the principal generator, preferring x when present.",
        examples: [
          {
            id: "poly_resultant_basic",
            label: "Eliminate x from two quadratics",
            description: "A univariate elimination example.",
            source: "(x^2 - y, x - 1)",
          },
          {
            id: "poly_resultant_dense",
            label: "Resultant of dense polynomials",
            description: "A denser symbolic elimination case.",
            source: "(x^2 + x + 1, x^2 - 1)",
          },
        ],
      }
    DocFunction::PolyGroebner =>
      {
        id,
        package_id: DocPackage::SymPolys,
        label: "groebner",
        module_path: "CAIMEOX/symbit/sympolys",
        signature: "groebner(polys: Array[Poly], order: TermOrder = Lex) -> Array[Poly]",
        summary: "Compute a Groebner basis for a polynomial system.",
        narrative: "Groebner bases turn a polynomial ideal into a canonical generating set relative to a term order. The browser view fixes the order to Lex to keep the front door stable.",
        interpretation: "Enter a tuple of two or more polynomial expressions. The result is the Lex-order basis returned by the actual sympolys engine.",
        examples: [
          {
            id: "poly_groebner_circle_line",
            label: "Circle-line system",
            description: "A small bivariate ideal with elimination flavor.",
            source: "(x^2 + y^2 - 1, x - y)",
          },
          {
            id: "poly_groebner_three",
            label: "Three-polynomial system",
            description: "A slightly larger ideal basis example.",
            source: "(x*y - 1, y - z, x - z)",
          },
        ],
      }
    DocFunction::NtIsPrime =>
      {
        id,
        package_id: DocPackage::SymNTheory,
        label: "isprime",
        module_path: "CAIMEOX/symbit/symntheory",
        signature: "isprime(n: Int) -> Bool",
        summary: "Test whether an exact integer is prime.",
        narrative: "This is the standard front door for exact primality testing. It is meant for arithmetic input, not symbolic predicates.",
        interpretation: "Enter one exact integer. The result is a boolean primality decision.",
        examples: [
          {
            id: "nt_isprime_prime",
            label: "Prime input",
            description: "A small prime should return true.",
            source: "101",
          },
          {
            id: "nt_isprime_composite",
            label: "Composite input",
            description: "A nearby composite should return false.",
            source: "121",
          },
        ],
      }
    DocFunction::NtFactorInt =>
      {
        id,
        package_id: DocPackage::SymNTheory,
        label: "factorint",
        module_path: "CAIMEOX/symbit/symntheory",
        signature: "factorint(n: Int) -> Map[Int, Int]",
        summary: "Factor an exact integer into prime powers.",
        narrative: "The output is the arithmetic factor map used throughout exact number theory work: primes as keys, exponents as values.",
        interpretation: "Enter one exact integer. The browser returns the factorization map rather than a symbolic product string.",
        examples: [
          {
            id: "nt_factorint_small",
            label: "Factor a medium composite",
            description: "A compact factor map with repeated primes.",
            source: "360",
          },
          {
            id: "nt_factorint_semiprime",
            label: "Factor a semiprime-like input",
            description: "A sparse factor map example.",
            source: "221",
          },
        ],
      }
    DocFunction::NtTotient =>
      {
        id,
        package_id: DocPackage::SymNTheory,
        label: "totient",
        module_path: "CAIMEOX/symbit/symntheory",
        signature: "totient(n: Int) -> Int",
        summary: "Compute Euler's totient function φ(n).",
        narrative: "The totient counts integers up to n that are coprime to n. It is one of the standard multiplicative arithmetic functions.",
        interpretation: "Enter one exact integer. The page returns the exact totient value.",
        examples: [
          {
            id: "nt_totient_prime_power",
            label: "Totient of a prime power",
            description: "A classic multiplicative example.",
            source: "27",
          },
          {
            id: "nt_totient_composite",
            label: "Totient of a composite",
            description: "Shows the effect of multiple prime factors.",
            source: "36",
          },
        ],
      }
    DocFunction::NtDivisorSigma =>
      {
        id,
        package_id: DocPackage::SymNTheory,
        label: "divisor_sigma",
        module_path: "CAIMEOX/symbit/symntheory",
        signature: "divisor_sigma(n: Int, k: Int = 1) -> Int",
        summary: "Compute the sum of k-th powers of the positive divisors of n.",
        narrative: "With k = 1 this is the ordinary sum-of-divisors function. Higher k values expose the same multiplicative structure through weighted divisor powers.",
        interpretation: "Enter either n or the tuple (n, k). The page returns the exact divisor-sigma value.",
        examples: [
          {
            id: "nt_divisor_sigma_sum",
            label: "Ordinary sum of divisors",
            description: "Uses the default exponent k = 1.",
            source: "12",
          },
          {
            id: "nt_divisor_sigma_weighted",
            label: "Weighted divisor sum",
            description: "Sums squares of divisors instead of raw divisors.",
            source: "(12, 2)",
          },
        ],
      }
    DocFunction::NtMobius =>
      {
        id,
        package_id: DocPackage::SymNTheory,
        label: "mobius",
        module_path: "CAIMEOX/symbit/symntheory",
        signature: "mobius(n: Int) -> Int",
        summary: "Evaluate the Möbius function μ(n).",
        narrative: "This arithmetic function distinguishes square-free inputs and tracks the parity of their prime support. It is a standard front door in multiplicative number theory.",
        interpretation: "Enter one exact integer. The result is -1, 0, or 1 depending on the prime structure of the input.",
        examples: [
          {
            id: "nt_mobius_squarefree",
            label: "Square-free composite",
            description: "An odd number of distinct prime factors gives -1.",
            source: "30",
          },
          {
            id: "nt_mobius_squareful",
            label: "Input with a repeated prime",
            description: "Any repeated prime factor forces zero.",
            source: "12",
          },
        ],
      }
    DocFunction::PhysMsigma =>
      {
        id,
        package_id: DocPackage::SymPhysics,
        label: "msigma",
        module_path: "CAIMEOX/symbit/symphysics",
        signature: "msigma(i: Int) -> ExplicitMatrix",
        summary: "Return the Pauli matrix σ_i for i = 1, 2, or 3.",
        narrative: "The Pauli matrices are the canonical 2×2 matrices used throughout spin and two-level quantum systems. This function is the explicit matrix-valued entry point rather than the purely algebraic symbolic one.",
        interpretation: "Enter a single integer index. The output is rendered as a concrete 2×2 matrix, so the page can be read the same way one reads a short reference table in a physics text.",
        examples: [
          {
            id: "physics_msigma_1",
            label: "First Pauli matrix",
            description: "The standard σ₁ matrix.",
            source: "1",
          },
        ],
      }
    DocFunction::PhysMgamma =>
      {
        id,
        package_id: DocPackage::SymPhysics,
        label: "mgamma",
        module_path: "CAIMEOX/symbit/symphysics",
        signature: "mgamma(mu: Int) -> ExplicitMatrix",
        summary: "Return a Dirac gamma matrix in the standard representation.",
        narrative: "Gamma matrices provide the matrix representation used in relativistic spinor calculations. The standard representation here matches the conventional Dirac basis and covers μ = 0, 1, 2, 3, 5.",
        interpretation: "Enter a single index. The browser prints the explicit 4×4 matrix so you can inspect the concrete representation directly.",
        examples: [
          {
            id: "physics_mgamma_1",
            label: "Spatial gamma matrix",
            description: "A standard nontrivial gamma-matrix example.",
            source: "1",
          },
        ],
      }
    DocFunction::PhysMdft =>
      {
        id,
        package_id: DocPackage::SymPhysics,
        label: "mdft",
        module_path: "CAIMEOX/symbit/symphysics",
        signature: "mdft(n: Int) -> ExplicitMatrix",
        summary: "Construct the explicit discrete Fourier transform matrix of order n.",
        narrative: "This helper builds the concrete Fourier matrix rather than a lazy symbolic transform object. It is useful when the goal is to inspect the actual coefficients or use the matrix in a small explicit calculation.",
        interpretation: "Enter an integer size. The result panel shows the explicit matrix rows, which keeps the example readable for small n.",
        examples: [
          {
            id: "physics_mdft_4",
            label: "Fourth-order DFT matrix",
            description: "A compact explicit Fourier matrix.",
            source: "4",
          },
        ],
      }
    DocFunction::PhysPatMatrix =>
      {
        id,
        package_id: DocPackage::SymPhysics,
        label: "pat_matrix",
        module_path: "CAIMEOX/symbit/symphysics",
        signature: "pat_matrix(m: Expr, dx: Expr, dy: Expr, dz: Expr) -> ExplicitMatrix",
        summary: "Return the Parallel Axis Theorem matrix for a mass translated by (dx, dy, dz).",
        narrative: "The Parallel Axis Theorem shifts an inertia matrix from one point to another by accounting for mass and displacement. This helper returns exactly that translation matrix.",
        interpretation: "Enter a tuple (m, dx, dy, dz). The output is the 3×3 translation matrix that can be added to an inertia tensor.",
        examples: [
          {
            id: "physics_pat_matrix",
            label: "Translate along the x-axis",
            description: "A mass-2 body shifted one unit along x.",
            source: "(2, 1, 0, 0)",
          },
        ],
      }
    DocFunction::PhysDelta =>
      {
        id,
        package_id: DocPackage::SymPhysics,
        label: "delta",
        module_path: "CAIMEOX/symbit/symphysics",
        signature: "delta(i: Int, j: Int) -> Int",
        summary: "Return 1 when two indices are equal and 0 otherwise.",
        narrative: "This is the Kronecker-delta-style helper used inside Pauli multiplication rules. It is intentionally small, because its main purpose is to make those algebraic formulas readable.",
        interpretation: "Enter a tuple (i, j). The result is an ordinary integer displayed directly in the output card.",
        examples: [
          {
            id: "physics_delta",
            label: "Unequal indices",
            description: "A minimal nontrivial delta example.",
            source: "(2, 3)",
          },
        ],
      }
    DocFunction::PhysEpsilon =>
      {
        id,
        package_id: DocPackage::SymPhysics,
        label: "epsilon",
        module_path: "CAIMEOX/symbit/symphysics",
        signature: "epsilon(i: Int, j: Int, k: Int) -> Int",
        summary: "Return the Levi-Civita sign for a triple of indices.",
        narrative: "The ε-symbol encodes orientation: cyclic permutations give 1, anti-cyclic permutations give -1, and repeated indices give 0. It appears naturally in Pauli and vector-product identities.",
        interpretation: "Enter a tuple (i, j, k). The browser returns the sign as an integer so the rule can be read immediately.",
        examples: [
          {
            id: "physics_epsilon",
            label: "Cyclic permutation",
            description: "A positive-orientation example.",
            source: "(1, 2, 3)",
          },
        ],
      }
    DocFunction::PhysPauli =>
      {
        id,
        package_id: DocPackage::SymPhysics,
        label: "pauli",
        module_path: "CAIMEOX/symbit/symphysics",
        signature: "pauli(i: Int) -> Expr",
        summary: "Construct an algebraic Pauli symbol rather than an explicit matrix.",
        narrative: "This entry lives on the algebra side of Pauli calculus. Instead of materializing a matrix, it returns a noncommutative symbolic object that can participate in products and power identities.",
        interpretation: "Enter a single index 1, 2, or 3. The output is a symbolic Pauli generator such as sigma1.",
        examples: [
          {
            id: "physics_pauli",
            label: "Symbolic Pauli generator",
            description: "The algebraic σ₂ element.",
            source: "2",
          },
        ],
      }
    DocFunction::PhysHydrogenENl =>
      {
        id,
        package_id: DocPackage::SymPhysics,
        label: "hydrogen_e_nl",
        module_path: "CAIMEOX/symbit/symphysics",
        signature: "hydrogen_e_nl(n: Int, z: Expr = 1) -> Expr",
        summary: "Return the nonrelativistic bound-state energy of a hydrogen-like atom.",
        narrative: "The energy depends on the principal quantum number and the atomic number. In atomic units the result is the familiar negative inverse-square law in n, scaled by Z².",
        interpretation: "Enter either n alone or a tuple (n, Z). This keeps the browser example close to textbook formulas for hydrogenic spectra.",
        examples: [
          {
            id: "physics_hydrogen_energy",
            label: "Ground-state energy",
            description: "The first bound-state energy level.",
            source: "1",
          },
        ],
      }
    DocFunction::PhysHydrogenRNl =>
      {
        id,
        package_id: DocPackage::SymPhysics,
        label: "hydrogen_r_nl",
        module_path: "CAIMEOX/symbit/symphysics",
        signature: "hydrogen_r_nl(n: Int, l: Int, r: Expr, z: Expr = 1) -> Expr",
        summary: "Return the radial hydrogen wavefunction R_nl.",
        narrative: "The radial factor is built from a normalization coefficient, an associated Laguerre polynomial, and an exponential decay term. It is the piece that carries the dependence on the radial coordinate.",
        interpretation: "Enter a tuple (n, l, r) or (n, l, r, Z). The output is the symbolic radial factor only, without the angular harmonic.",
        examples: [
          {
            id: "physics_hydrogen_radial",
            label: "First excited p radial mode",
            description: "A compact radial hydrogenic example.",
            source: "(2, 1, r)",
          },
        ],
      }
    DocFunction::PhysHydrogenYlm =>
      {
        id,
        package_id: DocPackage::SymPhysics,
        label: "hydrogen_y_lm",
        module_path: "CAIMEOX/symbit/symphysics",
        signature: "hydrogen_y_lm(l: Int, m: Int, phi: Expr, theta: Expr) -> Expr",
        summary: "Return the complex spherical harmonic Y_l^m used as the angular factor in hydrogenic orbitals.",
        narrative: "This function gives the angular part in the Condon-Shortley phase convention. Depending on the choice of m, the result can remain genuinely complex and is naturally expressed through exponential and trigonometric factors.",
        interpretation: "Enter a tuple (l, m, phi, theta). The browser prints the expanded angular function directly, so the dependence on both angles remains explicit.",
        examples: [
          {
            id: "physics_hydrogen_ylm",
            label: "First zonal harmonic",
            description: "The simplest nonconstant complex spherical harmonic.",
            source: "(1, 0, phi, theta)",
          },
        ],
      }
    DocFunction::PhysHydrogenZlm =>
      {
        id,
        package_id: DocPackage::SymPhysics,
        label: "hydrogen_z_lm",
        module_path: "CAIMEOX/symbit/symphysics",
        signature: "hydrogen_z_lm(l: Int, m: Int, phi: Expr, theta: Expr) -> Expr",
        summary: "Return the real spherical harmonic Z_l^m, the real angular basis often used in orbital pictures.",
        narrative: "The real spherical harmonics reorganize the complex basis into real combinations. They are the angular factors that match the familiar px, py, and dz2 style orbital visualizations used in chemistry and atomic physics.",
        interpretation: "Enter a tuple (l, m, phi, theta). The result is a real symbolic angular function, assuming the angle symbols are treated as real variables.",
        examples: [
          {
            id: "physics_hydrogen_zlm",
            label: "Real p-type harmonic",
            description: "A representative real spherical harmonic.",
            source: "(1, -1, phi, theta)",
          },
        ],
      }
    DocFunction::PhysHydrogenPsiNlm =>
      {
        id,
        package_id: DocPackage::SymPhysics,
        label: "hydrogen_psi_nlm",
        module_path: "CAIMEOX/symbit/symphysics",
        signature: "hydrogen_psi_nlm(n: Int, l: Int, m: Int, r: Expr, phi: Expr, theta: Expr, z: Expr = 1) -> Expr",
        summary: "Return the full hydrogen wavefunction ψ_nlm as radial part times angular harmonic.",
        narrative: "The full bound-state wavefunction combines the radial hydrogen factor with the spherical harmonic carrying the angular dependence. This is the symbolic object one uses when discussing orbitals rather than just energies.",
        interpretation: "Enter a tuple (n, l, m, r, phi, theta) or add Z as a seventh item. The result is printed as a single symbolic product.",
        examples: [
          {
            id: "physics_hydrogen_full",
            label: "A full orbital wavefunction",
            description: "A small complete ψ_nlm example.",
            source: "(2, 1, 0, r, phi, theta)",
          },
        ],
      }
    DocFunction::PhysWigner3j =>
      {
        id,
        package_id: DocPackage::SymPhysics,
        label: "wigner_3j",
        module_path: "CAIMEOX/symbit/symphysics",
        signature: "wigner_3j(j1: Expr, j2: Expr, j3: Expr, m1: Expr, m2: Expr, m3: Expr) -> Expr",
        summary: "Compute a Wigner 3j symbol exactly.",
        narrative: "Wigner symbols encode angular-momentum coupling rules. The 3j symbol is zero whenever the triangle relation or magnetic-number constraints fail, and otherwise evaluates to an exact radical expression.",
        interpretation: "Enter a 6-tuple of integer or half-integer values. The output remains symbolic rather than numeric so the exact structure is visible.",
        examples: [
          {
            id: "physics_wigner3j",
            label: "Exact 3j coefficient",
            description: "A standard exact radical example.",
            source: "(2, 6, 4, 0, 0, 0)",
          },
        ],
      }
    DocFunction::PhysClebschGordan =>
      {
        id,
        package_id: DocPackage::SymPhysics,
        label: "clebsch_gordan",
        module_path: "CAIMEOX/symbit/symphysics",
        signature: "clebsch_gordan(j1: Expr, j2: Expr, j3: Expr, m1: Expr, m2: Expr, m3: Expr) -> Expr",
        summary: "Compute a Clebsch-Gordan coefficient for angular-momentum coupling.",
        narrative: "Clebsch-Gordan coefficients describe how tensor-product states decompose into coupled angular-momentum states. The implementation returns exact symbolic values rather than floating approximations.",
        interpretation: "Enter a 6-tuple (j1, j2, j3, m1, m2, m3). Half-integers can be entered as rational numbers such as 1/2 or 3/2.",
        examples: [
          {
            id: "physics_clebsch",
            label: "Half-integer coupling",
            description: "A common spin-coupling example.",
            source: "(3/2, 1/2, 2, 3/2, 1/2, 2)",
          },
        ],
      }
    DocFunction::PhysGaunt =>
      {
        id,
        package_id: DocPackage::SymPhysics,
        label: "gaunt",
        module_path: "CAIMEOX/symbit/symphysics",
        signature: "gaunt(l1: Int, l2: Int, l3: Int, m1: Int, m2: Int, m3: Int) -> Expr",
        summary: "Compute the Gaunt coefficient for three spherical harmonics.",
        narrative: "Gaunt coefficients appear in products and integrals of spherical harmonics. Like the Wigner symbols, they are returned exactly as rational multiples of square roots of rationals when possible.",
        interpretation: "Enter the six angular indices as a tuple. The page shows the exact coefficient, not a rounded numeric value.",
        examples: [
          {
            id: "physics_gaunt",
            label: "Three-harmonic coupling coefficient",
            description: "A small exact Gaunt-coefficient example.",
            source: "(1, 0, 1, 1, 0, -1)",
          },
        ],
      }
    DocFunction::PhysRefractionAngle =>
      {
        id,
        package_id: DocPackage::SymPhysics,
        label: "refraction_angle",
        module_path: "CAIMEOX/symbit/symphysics",
        signature: "refraction_angle(theta: Expr, n1: Expr, n2: Expr) -> Expr",
        summary: "Return the angle of refraction for a planar interface.",
        narrative: "When the incident quantity is an angle instead of a geometric ray, the function reduces to the scalar Snell-law branch. That makes it a good compact front door for analytic optics examples.",
        interpretation: "Enter a tuple (incident_angle, n1, n2). The page intentionally uses the scalar branch so the result stays readable inside a documentation pane.",
        examples: [
          {
            id: "physics_refraction_angle",
            label: "Snell-law refraction",
            description: "Incidence at π/6 from index 1 into 3/2.",
            source: "(pi/6, 1, 3/2)",
          },
        ],
      }
    DocFunction::PhysBrewsterAngle =>
      {
        id,
        package_id: DocPackage::SymPhysics,
        label: "brewster_angle",
        module_path: "CAIMEOX/symbit/symphysics",
        signature: "brewster_angle(n1: Expr, n2: Expr) -> Expr",
        summary: "Return the incidence angle at which p-polarized reflection vanishes.",
        narrative: "Brewster's angle is the incidence angle for which the reflected and refracted rays are orthogonal and the parallel-polarized reflection coefficient becomes zero.",
        interpretation: "Enter a tuple (n1, n2). The result is a symbolic angle, usually an arctangent-based expression.",
        examples: [
          {
            id: "physics_brewster",
            label: "Brewster angle between two indices",
            description: "A standard two-medium optics computation.",
            source: "(1, 3/2)",
          },
        ],
      }
    DocFunction::PhysCriticalAngle =>
      {
        id,
        package_id: DocPackage::SymPhysics,
        label: "critical_angle",
        module_path: "CAIMEOX/symbit/symphysics",
        signature: "critical_angle(n1: Expr, n2: Expr) -> Expr",
        summary: "Return the threshold angle for total internal reflection.",
        narrative: "The critical angle is defined when light travels from a higher index to a lower index medium. Beyond this angle the transmitted branch disappears and total internal reflection occurs.",
        interpretation: "Enter a tuple (n1, n2). The page uses bare refractive indices as the optics-medium inputs.",
        examples: [
          {
            id: "physics_critical",
            label: "Critical angle from glass to air",
            description: "A higher-to-lower index example.",
            source: "(3/2, 1)",
          },
        ],
      }
    DocFunction::PhysFresnelCoefficients =>
      {
        id,
        package_id: DocPackage::SymPhysics,
        label: "fresnel_coefficients",
        module_path: "CAIMEOX/symbit/symphysics",
        signature: "fresnel_coefficients(theta: Expr, n1: Expr, n2: Expr) -> Array[Expr]",
        summary: "Return the reflection and transmission Fresnel coefficients for both polarizations.",
        narrative: "The result lists the p- and s-polarized reflection and transmission coefficients for a plane interface. This is the compact coefficient-level view of the same boundary-value physics encoded in refraction and Brewster-angle formulas.",
        interpretation: "Enter a tuple (incident_angle, n1, n2). The output is a four-entry list in the standard p/s ordering.",
        examples: [
          {
            id: "physics_fresnel",
            label: "Fresnel coefficient tuple",
            description: "A small coefficient computation at a fixed angle.",
            source: "(3/10, 1, 2)",
          },
        ],
      }
    DocFunction::PhysJonesVector =>
      {
        id,
        package_id: DocPackage::SymPhysics,
        label: "jones_vector",
        module_path: "CAIMEOX/symbit/symphysics",
        signature: "jones_vector(psi: Expr, chi: Expr) -> ExplicitMatrix",
        summary: "Return a Jones vector for a polarization ellipse with tilt psi and circularity chi.",
        narrative: "Jones vectors encode fully polarized optical fields in a two-component complex vector. The parameters psi and chi describe the orientation and circularity of the polarization ellipse.",
        interpretation: "Enter a tuple (psi, chi). The result is displayed as a 2×1 matrix so the polarization state can be read directly.",
        examples: [
          {
            id: "physics_jones",
            label: "Horizontal polarization",
            description: "The simplest Jones-vector basis state.",
            source: "(0, 0)",
          },
        ],
      }
    DocFunction::PhysStokesVector =>
      {
        id,
        package_id: DocPackage::SymPhysics,
        label: "stokes_vector",
        module_path: "CAIMEOX/symbit/symphysics",
        signature: "stokes_vector(psi: Expr, chi: Expr, p: Expr = 1, intensity: Expr = 1) -> ExplicitMatrix",
        summary: "Return a Stokes vector for a polarization ellipse.",
        narrative: "Stokes vectors encode polarization in a form that can represent partially polarized light as well as total intensity. The entries correspond to the standard Stokes parameters.",
        interpretation: "Enter either (psi, chi) or (psi, chi, p, I0). The output is a 4×1 vector with the usual intensity-first convention.",
        examples: [
          {
            id: "physics_stokes",
            label: "Parameterized Stokes vector",
            description: "A symbolic Stokes-vector example with degree of polarization and intensity.",
            source: "(psi, chi, p, I0)",
          },
        ],
      }
    DocFunction::PhysFreeSpace =>
      {
        id,
        package_id: DocPackage::SymPhysics,
        label: "free_space",
        module_path: "CAIMEOX/symbit/symphysics",
        signature: "free_space(d: Expr) -> RayTransferMatrix",
        summary: "Return the ABCD matrix for free-space propagation over a distance d.",
        narrative: "In paraxial optics, propagation through free space is represented by the simplest nontrivial ray-transfer matrix: position shifts while angle stays unchanged.",
        interpretation: "Enter a single distance expression. The result is printed as the explicit 2×2 ABCD matrix.",
        examples: [
          {
            id: "physics_free_space",
            label: "Symbolic propagation matrix",
            description: "A free-space transfer matrix with symbolic distance.",
            source: "d",
          },
        ],
      }
    DocFunction::PhysFlatRefraction =>
      {
        id,
        package_id: DocPackage::SymPhysics,
        label: "flat_refraction",
        module_path: "CAIMEOX/symbit/symphysics",
        signature: "flat_refraction(n1: Expr, n2: Expr) -> RayTransferMatrix",
        summary: "Return the ABCD matrix for refraction at a planar interface.",
        narrative: "A flat interface changes the ray angle through the refractive-index ratio but leaves the height coordinate untouched. In ray-transfer form that means the only nontrivial entry is the lower-right scaling factor.",
        interpretation: "Enter a tuple (n1, n2). The page renders the explicit 2×2 matrix so the interface law can be read at a glance.",
        examples: [
          {
            id: "physics_flat_refraction",
            label: "Planar interface matrix",
            description: "Refraction from index n1 into n2.",
            source: "(n1, n2)",
          },
        ],
      }
    DocFunction::PhysCurvedRefraction =>
      {
        id,
        package_id: DocPackage::SymPhysics,
        label: "curved_refraction",
        module_path: "CAIMEOX/symbit/symphysics",
        signature: "curved_refraction(R: Expr, n1: Expr, n2: Expr) -> RayTransferMatrix",
        summary: "Return the ABCD matrix for refraction across a curved interface.",
        narrative: "A curved refracting surface contributes focusing power as well as the usual refractive-index scaling. The matrix therefore acquires a nonzero lower-left entry proportional to (n1 - n2)/(R*n2).",
        interpretation: "Enter a tuple (R, n1, n2). The result is shown as a symbolic ray-transfer matrix.",
        examples: [
          {
            id: "physics_curved_refraction",
            label: "Curved interface matrix",
            description: "A refracting surface with symbolic radius and indices.",
            source: "(R, n1, n2)",
          },
        ],
      }
    DocFunction::PhysCurvedMirror =>
      {
        id,
        package_id: DocPackage::SymPhysics,
        label: "curved_mirror",
        module_path: "CAIMEOX/symbit/symphysics",
        signature: "curved_mirror(R: Expr) -> RayTransferMatrix",
        summary: "Return the ABCD matrix for reflection from a curved mirror.",
        narrative: "The curved-mirror matrix is the reflective analogue of a focusing element. Its power appears in the lower-left entry as -2/R, which is why the radius sign convention matters in paraxial optics.",
        interpretation: "Enter a single radius expression. The output is the explicit 2×2 ray-transfer matrix.",
        examples: [
          {
            id: "physics_curved_mirror",
            label: "Curved mirror matrix",
            description: "A symbolic curved-mirror transfer matrix.",
            source: "R",
          },
        ],
      }
    DocFunction::PhysThinLens =>
      {
        id,
        package_id: DocPackage::SymPhysics,
        label: "thin_lens",
        module_path: "CAIMEOX/symbit/symphysics",
        signature: "thin_lens(f: Expr) -> RayTransferMatrix",
        summary: "Return the ABCD matrix for a thin lens of focal length f.",
        narrative: "The thin-lens matrix is the canonical converging or diverging element in paraxial ray-transfer analysis. Its off-diagonal structure captures the focusing power of the lens.",
        interpretation: "Enter a single focal-length expression. The result is shown as a 2×2 matrix in the same notation used in Gaussian-optics tables.",
        examples: [
          {
            id: "physics_thin_lens",
            label: "Symbolic lens matrix",
            description: "A thin-lens transfer matrix with focal length f.",
            source: "f",
          },
        ],
      }
    DocFunction::PhysLinearPolarizer =>
      {
        id,
        package_id: DocPackage::SymPhysics,
        label: "linear_polarizer",
        module_path: "CAIMEOX/symbit/symphysics",
        signature: "linear_polarizer(theta: Expr) -> ExplicitMatrix",
        summary: "Return the Jones matrix of an ideal linear polarizer whose transmission axis is tilted by theta.",
        narrative: "The matrix projects the field onto a single linear polarization direction. Its entries are built from the familiar sin(theta) and cos(theta) combinations that encode the transmission axis.",
        interpretation: "Enter a single angle. The result is rendered as a 2×2 Jones matrix rather than a higher-level optics object.",
        examples: [
          {
            id: "physics_linear_polarizer",
            label: "Tilted polarizer",
            description: "An ideal polarizer at angle theta.",
            source: "theta",
          },
        ],
      }
    DocFunction::PhysPhaseRetarder =>
      {
        id,
        package_id: DocPackage::SymPhysics,
        label: "phase_retarder",
        module_path: "CAIMEOX/symbit/symphysics",
        signature: "phase_retarder(theta: Expr, delta: Expr) -> ExplicitMatrix",
        summary: "Return the Jones matrix of a phase retarder with fast-axis angle theta and retardance delta.",
        narrative: "A retarder preserves amplitude while shifting phase between orthogonal axes. The full matrix keeps both the axis orientation and the phase lag visible, so it is the natural parent object for quarter-wave and half-wave plates.",
        interpretation: "Enter a tuple (theta, delta). The output is the explicit Jones matrix, which keeps the phase structure readable without any extra expansion step.",
        examples: [
          {
            id: "physics_phase_retarder",
            label: "Generic retarder",
            description: "A symbolic retarder with axis theta and retardance delta.",
            source: "(theta, delta)",
          },
        ],
      }
    DocFunction::PhysHalfWaveRetarder =>
      {
        id,
        package_id: DocPackage::SymPhysics,
        label: "half_wave_retarder",
        module_path: "CAIMEOX/symbit/symphysics",
        signature: "half_wave_retarder(theta: Expr) -> ExplicitMatrix",
        summary: "Return the Jones matrix of a half-wave plate rotated by theta.",
        narrative: "A half-wave plate is a retarder with phase lag pi. It flips handedness and rotates linear polarization relative to the fast axis, so it serves as a standard polarization-control element.",
        interpretation: "Enter a single angle. The browser returns the explicit Jones matrix so the special pi retardance remains visible in the coefficients.",
        examples: [
          {
            id: "physics_half_wave",
            label: "Half-wave plate",
            description: "A symbolic half-wave retarder.",
            source: "theta",
          },
        ],
      }
    DocFunction::PhysQuarterWaveRetarder =>
      {
        id,
        package_id: DocPackage::SymPhysics,
        label: "quarter_wave_retarder",
        module_path: "CAIMEOX/symbit/symphysics",
        signature: "quarter_wave_retarder(theta: Expr) -> ExplicitMatrix",
        summary: "Return the Jones matrix of a quarter-wave plate rotated by theta.",
        narrative: "A quarter-wave plate introduces a pi/2 phase shift between the fast and slow axes. That is the standard element for converting between linear and circular or elliptical polarization states.",
        interpretation: "Enter a single angle. The output stays in explicit matrix form so the phase-shift structure can be inspected directly.",
        examples: [
          {
            id: "physics_quarter_wave",
            label: "Quarter-wave plate",
            description: "A symbolic quarter-wave retarder.",
            source: "theta",
          },
        ],
      }
    DocFunction::Solve =>
      {
        id,
        package_id: DocPackage::SymSolvers,
        label: "solve",
        module_path: "CAIMEOX/symbit/symsolvers",
        signature: "solve(expr: Expr, symbols: Array[Symbol] = [x]) -> SolveResult",
        summary: "Solve an algebraic equation for the principal symbol x.",
        narrative: "SymPy's classic solve front door returns lists or dictionaries depending on the problem shape. This page keeps the simplest scalar branch and renders the exact result container.",
        interpretation: "The input is interpreted as an equation equal to zero, which is the standard textbook reading and matches SymPy's default solve front door.",
        examples: [
          {
            id: "solve_quadratic",
            label: "Quadratic roots",
            description: "The canonical scalar solver example.",
            source: "x^2 - 4",
          },
          {
            id: "solve_complex",
            label: "Complex-valued roots",
            description: "Shows that the solver is not restricted to real roots.",
            source: "x^2 + 1",
          },
        ],
      }
    DocFunction::SolveSet =>
      {
        id,
        package_id: DocPackage::SymSolvers,
        label: "solveset",
        module_path: "CAIMEOX/symbit/symsolvers",
        signature: "solveset(expr: Expr, symbol: Symbol = x, domain: Set = Complexes) -> Set",
        summary: "Return a set-valued solution object for an equation in x.",
        narrative: "This section tracks the SymPy distinction between solve and solveset: the former is convenience-oriented, the latter is set-oriented and prints as a mathematical object.",
        interpretation: "The page fixes the domain to Complexes so the result is deterministic and easy to compare against SymPy-style documentation.",
        examples: [
          {
            id: "solveset_quadratic",
            label: "Finite solution set",
            description: "A short example with two explicit roots.",
            source: "x^2 - 4",
          },
          {
            id: "solveset_trig",
            label: "Condition-style trigonometric family",
            description: "Shows that the result may be more structured than a list.",
            source: "sin(x)",
          },
        ],
      }
    DocFunction::Decompogen =>
      {
        id,
        package_id: DocPackage::SymSolvers,
        label: "decompogen",
        module_path: "CAIMEOX/symbit/symsolvers",
        signature: "decompogen(expr: Expr, symbol: Symbol) -> Array[Expr]",
        summary: "Extract a functional composition chain with respect to x.",
        narrative: "SymPy documents decompogen as a solver-adjacent structural tool. It fits a literate page especially well because the output is naturally a sequence of layers.",
        interpretation: "The result panel prints the composition chain in order, so the user can read it top-down like a derivation.",
        examples: [
          {
            id: "decompogen_nested",
            label: "Nested trigonometric composition",
            description: "A compact composition chain with two layers.",
            source: "sin(cos(x))",
          },
          {
            id: "decompogen_algebraic",
            label: "Algebraic outer wrapper",
            description: "A solver-side decomposition example with radicals.",
            source: "sqrt(6*x^2 - 5)",
          },
        ],
      }
  }
}

///|
fn function_catalog(pkg : DocPackage) -> Array[FunctionDoc] {
  package_doc(pkg).functions.map(function_doc)
}

///|
fn function_topic(id : DocFunction) -> String {
  match id {
    DocFunction::Simplify => "simplify"
    DocFunction::TrigSimp => "simplify"
    DocFunction::RatSimp => "simplify"
    DocFunction::Diff => "calculus"
    DocFunction::Periodicity => "calculus"
    DocFunction::Singularities => "calculus"
    DocFunction::Integrate => "integrals"
    DocFunction::SeriesExpand => "series"
    DocFunction::Limit => "series"
    DocFunction::Residue => "series"
    DocFunction::SetInterval => "sets"
    DocFunction::SetFinite => "sets"
    DocFunction::SetContains => "sets"
    DocFunction::Summation => "concrete"
    DocFunction::Product => "concrete"
    DocFunction::Rationalize => "concrete"
    DocFunction::DiscreteFFT => "discrete"
    DocFunction::DiscreteIFFT => "discrete"
    DocFunction::DiscreteFWHT => "discrete"
    DocFunction::DiscreteMobius => "discrete"
    DocFunction::TermsGcd => "polys"
    DocFunction::PolyFactor => "polys"
    DocFunction::PolyFactorList => "polys"
    DocFunction::PolySqfPart => "polys"
    DocFunction::PolySqfList => "polys"
    DocFunction::PolyCancel => "polys"
    DocFunction::PolyCompose => "polys"
    DocFunction::Decompose => "polys"
    DocFunction::PolyGcd => "polys"
    DocFunction::PolyDiscriminant => "polys"
    DocFunction::PolyResultant => "polys"
    DocFunction::PolyGroebner => "polys"
    DocFunction::NtIsPrime => "ntheory"
    DocFunction::NtFactorInt => "ntheory"
    DocFunction::NtTotient => "ntheory"
    DocFunction::NtDivisorSigma => "ntheory"
    DocFunction::NtMobius => "ntheory"
    DocFunction::PhysMsigma => "physics.matrices"
    DocFunction::PhysMgamma => "physics.matrices"
    DocFunction::PhysMdft => "physics.matrices"
    DocFunction::PhysPatMatrix => "physics.matrices"
    DocFunction::PhysDelta => "physics.paulialgebra"
    DocFunction::PhysEpsilon => "physics.paulialgebra"
    DocFunction::PhysPauli => "physics.paulialgebra"
    DocFunction::PhysHydrogenENl => "physics.hydrogen"
    DocFunction::PhysHydrogenRNl => "physics.hydrogen"
    DocFunction::PhysHydrogenYlm => "physics.hydrogen"
    DocFunction::PhysHydrogenZlm => "physics.hydrogen"
    DocFunction::PhysHydrogenPsiNlm => "physics.hydrogen"
    DocFunction::PhysWigner3j => "physics.wigner"
    DocFunction::PhysClebschGordan => "physics.wigner"
    DocFunction::PhysGaunt => "physics.wigner"
    DocFunction::PhysRefractionAngle => "physics.optics"
    DocFunction::PhysBrewsterAngle => "physics.optics"
    DocFunction::PhysCriticalAngle => "physics.optics"
    DocFunction::PhysFresnelCoefficients => "physics.optics"
    DocFunction::PhysJonesVector => "physics.optics.polarization"
    DocFunction::PhysStokesVector => "physics.optics.polarization"
    DocFunction::PhysFreeSpace => "physics.optics.gaussopt"
    DocFunction::PhysFlatRefraction => "physics.optics.gaussopt"
    DocFunction::PhysCurvedRefraction => "physics.optics.gaussopt"
    DocFunction::PhysCurvedMirror => "physics.optics.gaussopt"
    DocFunction::PhysThinLens => "physics.optics.gaussopt"
    DocFunction::PhysLinearPolarizer => "physics.optics.polarization"
    DocFunction::PhysPhaseRetarder => "physics.optics.polarization"
    DocFunction::PhysHalfWaveRetarder => "physics.optics.polarization"
    DocFunction::PhysQuarterWaveRetarder => "physics.optics.polarization"
    DocFunction::Solve => "solvers"
    DocFunction::SolveSet => "solvers"
    DocFunction::Decompogen => "solvers"
  }
}

///|
fn function_input_format(id : DocFunction) -> String {
  match id {
    DocFunction::Simplify => "expr"
    DocFunction::TrigSimp => "expr"
    DocFunction::RatSimp => "expr"
    DocFunction::Diff => "expr"
    DocFunction::Periodicity => "expr"
    DocFunction::Singularities => "expr"
    DocFunction::Integrate => "expr"
    DocFunction::SeriesExpand => "expr"
    DocFunction::Limit => "expr"
    DocFunction::Residue => "expr"
    DocFunction::SetInterval => "tuple"
    DocFunction::SetFinite => "tuple"
    DocFunction::SetContains => "tuple"
    DocFunction::Summation => "tuple"
    DocFunction::Product => "tuple"
    DocFunction::Rationalize => "expr"
    DocFunction::DiscreteFFT => "tuple"
    DocFunction::DiscreteIFFT => "tuple"
    DocFunction::DiscreteFWHT => "tuple"
    DocFunction::DiscreteMobius => "tuple"
    DocFunction::TermsGcd => "expr"
    DocFunction::PolyFactor => "expr"
    DocFunction::PolyFactorList => "expr"
    DocFunction::PolySqfPart => "expr"
    DocFunction::PolySqfList => "expr"
    DocFunction::PolyCancel => "(num, den)"
    DocFunction::PolyCompose => "(f, g)"
    DocFunction::Decompose => "expr"
    DocFunction::PolyGcd => "(f, g)"
    DocFunction::PolyDiscriminant => "expr"
    DocFunction::PolyResultant => "(f, g)"
    DocFunction::PolyGroebner => "(f1, f2, ..., fn)"
    DocFunction::NtIsPrime => "n"
    DocFunction::NtFactorInt => "n"
    DocFunction::NtTotient => "n"
    DocFunction::NtDivisorSigma => "n or (n, k)"
    DocFunction::NtMobius => "n"
    DocFunction::PhysMsigma => "i"
    DocFunction::PhysMgamma => "mu"
    DocFunction::PhysMdft => "n"
    DocFunction::PhysPatMatrix => "(m, dx, dy, dz)"
    DocFunction::PhysDelta => "(i, j)"
    DocFunction::PhysEpsilon => "(i, j, k)"
    DocFunction::PhysPauli => "i"
    DocFunction::PhysHydrogenENl => "n or (n, Z)"
    DocFunction::PhysHydrogenRNl => "(n, l, r) or (n, l, r, Z)"
    DocFunction::PhysHydrogenYlm => "(l, m, phi, theta)"
    DocFunction::PhysHydrogenZlm => "(l, m, phi, theta)"
    DocFunction::PhysHydrogenPsiNlm => "(n, l, m, r, phi, theta) or (..., Z)"
    DocFunction::PhysWigner3j => "(j1, j2, j3, m1, m2, m3)"
    DocFunction::PhysClebschGordan => "(j1, j2, j3, m1, m2, m3)"
    DocFunction::PhysGaunt => "(l1, l2, l3, m1, m2, m3)"
    DocFunction::PhysRefractionAngle => "(theta, n1, n2)"
    DocFunction::PhysBrewsterAngle => "(n1, n2)"
    DocFunction::PhysCriticalAngle => "(n1, n2)"
    DocFunction::PhysFresnelCoefficients => "(theta, n1, n2)"
    DocFunction::PhysJonesVector => "(psi, chi)"
    DocFunction::PhysStokesVector => "(psi, chi) or (psi, chi, p, I0)"
    DocFunction::PhysFreeSpace => "d"
    DocFunction::PhysFlatRefraction => "(n1, n2)"
    DocFunction::PhysCurvedRefraction => "(R, n1, n2)"
    DocFunction::PhysCurvedMirror => "R"
    DocFunction::PhysThinLens => "f"
    DocFunction::PhysLinearPolarizer => "theta"
    DocFunction::PhysPhaseRetarder => "(theta, delta)"
    DocFunction::PhysHalfWaveRetarder => "theta"
    DocFunction::PhysQuarterWaveRetarder => "theta"
    DocFunction::Solve => "expr"
    DocFunction::SolveSet => "expr"
    DocFunction::Decompogen => "expr"
  }
}

///|
fn default_package() -> DocPackage {
  DocPackage::SymSimplify
}

///|
fn default_function(pkg : DocPackage) -> DocFunction {
  package_doc(pkg).functions[0]
}

///|
fn default_example(function_id : DocFunction) -> FunctionExample {
  function_doc(function_id).examples[0]
}

///|
fn example_by_id(function_id : DocFunction, id : String) -> FunctionExample? {
  for item in function_doc(function_id).examples {
    if item.id == id {
      return Some(item)
    }
  }
  None
}
