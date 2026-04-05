///|
#cfg(target="js")
fn main {
  @rabbita.new(@playground.algebra_app()).mount("app")
}

///|
#cfg(target="native")
fn main {
  println(
    "Build the Algebra Playground with `moon run cmd/web --target js --build-only` and open public/index.html.",
  )
}
