context("Test removing a row works")


test_reactive_vals <- shiny::reactiveValues()
test_reactive_vals$click <- data.frame(x_values = c(1, 2, 3, 4),
                                             y_values = c(5, 6, 7, 8))

test_one_removed_data <- data.frame(x_values = c(1, 2, 3),
                                    y_values = c(5, 6, 7))

test_that("Removing a row works", {
  expect_equal(shiny::isolate({remove_last_row(test_reactive_vals)$click}),
               test_one_removed_data)
})

test_reactive_vals2 <- shiny::reactiveValues()
test_reactive_vals2$click <- data.frame(x_values = c(1, 2, 3, 4),
                                            y_values = c(5, 6, 7, 8))

test_two_removed_data <- data.frame(x_values = c(1, 2),
                                    y_values = c(5, 6))

test_that("Repeatedly removing a row works", {
  expect_equal(shiny::isolate({remove_last_row(remove_last_row(test_reactive_vals2))$click}),
               test_two_removed_data)
})

rm(test_reactive_vals)
rm(test_one_removed_data)
rm(test_reactive_vals2)
rm(test_two_removed_data)
