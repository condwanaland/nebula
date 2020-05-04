# Create reactive dataframes to store click and transect data in.

# Dataframe for single click data
click_data <- shiny::reactiveValues()
click_data$click <- create_empty_df("x_values", "y_values")
output_data <- shiny::reactive({click_data$click})

# Dataframe for transect data (double click and hover)
transect_data <- shiny::reactiveValues(n = 1)
transect_data$double_click <- data.frame(x_values=c(NA_real_,NA_real_),
                                         y_values = c(NA_real_,NA_real_))
