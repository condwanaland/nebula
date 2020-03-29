#' create_empty_df
#'
#' Creates an empty numeric dataframe to store coordinates
#'
#' @param x_values Name of the x column
#' @param y_values Name of the y column
#'
#' @return a 2 column dataframe with no values
#' @kewyords internal
#' @noRd
#'
create_empty_df <- function(x_values = "x_values", y_values = "y_values"){
  cols <- list(x_values, y_values)
  empty_df <- data.frame(x_values = numeric(),
                         y_values = numeric())

  colnames(empty_df) <- cols
  return(empty_df)
}
