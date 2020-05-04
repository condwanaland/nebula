show_click <- function(click_data, x_val, y_val) {
  add_row <- data.frame(x_values = x_val,
                        y_values = y_val)

  click_data$click <- rbind(click_data$click, add_row)
}
