///|
#cfg(target="js")
fn main {
  @playground.algebra_web_app().mount("app")
}

///|
#cfg(target="native")
fn main {
  println(
    "Build the Algebra Playground with `moon run cmd/web --target js --build-only` and open public/index.html.",
  )
}
