context("Effects")

allowed_effects <- list("negate", "charcoal", "edge", "despeckle", "reduce_noise")

test_that("All allowed effects are present", {
  expect_equal(effects_list(), allowed_effects)
})
