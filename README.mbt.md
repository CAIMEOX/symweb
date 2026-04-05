# SymBit Playground

SymBit Playground is a browser-based reference surface for the `symbit` symbolic stack.
It pairs a documentation-style navigation tree with a live `wasm` compute kernel, so expressions can be parsed, normalized, and evaluated directly in the page.

The current UI focuses on a compact set of front-door modules:

- `symsimplify`, `symcalculus`, `symintegrals`
- `symseries`, `sympolys`, `symntheory`
- `symphysics`, `symsolvers`

Each function page is designed as a small executable note:

- choose a package and function from the left tree
- edit the example input
- wait for the auto-run debounce
- inspect the parsed expression, structural form, and final result

The page itself is compiled to JavaScript with `rabbita`, while the symbolic kernel is built as plain `wasm` and loaded from the frontend through a small UTF-8 JavaScript glue layer.
