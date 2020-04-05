#' module definitions for the reset button module
#'
#' This module starts a modal that confirms whether the user wants to reset nebula back to its original state when loaded. This is useful when you have finished analysing a otolith image, and want to open a new one.
#'
#' @keywords internal
#'
#' @importFrom shiny NS actionButton observeEvent showModal modalDialog tagList
resetButtonUI <- function(id, label = "Reset All"){
  ns <- NS(id)

  actionButton(ns("resetAll"), "Reset all")
}

resetButton <- function(input, output, session){
  observeEvent(input$resetAll, {
    showModal(modalDialog(
      tagList(
        tagList(actionButton("confirmDelete", "Delete all points")
        )),
      title="Warning: this will delete all points currently marked",
      easyClose = TRUE,
      fade = TRUE
    ))
  })
}
