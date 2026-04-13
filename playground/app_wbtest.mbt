///|
test "playground plot scaling keeps equal x and y units for circular bounds" {
  let center_x = plot_scale_x(0.0, -1.0, 1.0, -1.0, 1.0)
  let center_y = plot_scale_y(0.0, -1.0, 1.0, -1.0, 1.0)
  let radius_x = (plot_scale_x(1.0, -1.0, 1.0, -1.0, 1.0) - center_x).abs()
  let radius_y = (plot_scale_y(1.0, -1.0, 1.0, -1.0, 1.0) - center_y).abs()
  assert_true((radius_x - radius_y).abs() <= 1)
}

///|
test "playground plot scaling centers the shorter axis when spans differ" {
  let left = plot_scale_x(0.0, 0.0, 4.0, 0.0, 1.0)
  let right = plot_scale_x(4.0, 0.0, 4.0, 0.0, 1.0)
  let top = plot_scale_y(1.0, 0.0, 4.0, 0.0, 1.0)
  let bottom = plot_scale_y(0.0, 0.0, 4.0, 0.0, 1.0)
  assert_true((right - left) > (bottom - top))
  assert_true(top > plot_padding())
  assert_true(bottom < plot_height() - plot_padding())
}

///|
test "playground topbar exposes github source button" {
  assert_eq(github_button_label(), "GitHub")
  assert_eq(github_repo_url(), "https://github.com/CAIMEOX/symbit")
}
