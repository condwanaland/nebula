#' deletePointUI
#'
#' UI for the module that removes the last row in the dataframe of clicks.
#'
#' @keywords internal
#'
deletePointUI <- function(id, label = "Delete Last Point"){
  ns <- NS(id)

  actionButton(ns("delete_point"), label = "Delete Point")
}

deletePoint <- function(input, output, session, click_data){
  observeEvent(input$delete_point, {
    remove_last_row(click_data)
  })
}

#' remove_last_row
#'
#' Removes the last row from a reactive dataframe
#'
#' @param click_data
#'
#' @return A new reactive dataframe, with the last row removed
#' @keywords internal
#'
remove_last_row <- function(click_data){
  dat_without_last_row <- click_data$click[-nrow(click_data$click), ]
  click_data$click <- dat_without_last_row
  return(click_data)
}
