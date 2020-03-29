context("Empty dataframes to store values")

test_df <- data.frame(x_values = numeric(),
                       y_values = numeric())

test_that("empty df has correct structure",{
  expect_equal(test_df, create_empty_df())
})

test_df2 <- data.frame(test_x = numeric(),
                      test_y = numeric())

test_that("empty df colnames correctly",{
  expect_equal(test_df2, create_empty_df("test_x", "test_y"))
})

rm(test_df)
rm(test_df2)
