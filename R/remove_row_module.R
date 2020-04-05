#' deletePointUI
#'
#' UI for the module that removes the last row in the dataframe of clicks.
#'
#' @keywords internal
#'
#' @importFrom shiny NS actionButton observeEvent
deletePointUI <- function(id, label = "Delete Last Point"){
  ns <- NS(id)

  actionButton(ns("delete_point"), label = "Delete Point")
}

deletePoint <- function(input, output, session, click_data_reactive){
  observeEvent(input$delete_point, {
    remove_last_row(click_data_reactive)
  })
}

#' remove_last_row
#'
#' Removes the last row from a reactive dataframe
#'
#' @param click_data_reactive
#'
#' @return A new reactive dataframe, with the last row removed
#' @keywords internal
#'
remove_last_row <- function(click_data_reactive){
  dat_without_last_row <- click_data_reactive$click_data[-nrow(click_data_reactive$click_data), ]
  click_data_reactive$click_data <- dat_without_last_row
  return(click_data_reactive)
}
