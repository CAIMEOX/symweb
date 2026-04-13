///|
test "playground sidebar catalog includes symplotting near the top-level package list" {
  let packages = package_catalog()
  inspect(packages.length(), content="15")
  inspect(packages[4].label, content="symplotting")
}

///|
test "playground plotting package exposes all registered plotting front doors" {
  let functions = function_catalog(DocPackage::SymPlotting)
  inspect(functions.length(), content="4")
  inspect(functions[0].label, content="textplot")
  inspect(functions[1].label, content="plot")
  inspect(functions[2].label, content="plot_parametric")
  inspect(functions[3].label, content="plot_implicit")
  inspect(
    function_doc(default_function(DocPackage::SymPlotting)).label,
    content="textplot",
  )
}
