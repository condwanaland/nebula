#' module definitions for the reset button module
#'
#' This module starts a modal that confirms whether the user wants to reset nebula back to its original state when loaded. This is useful when you have finished analysing a otolith image, and want to open a new one.
#'
#' @keywords internal
#' @name ResetButtonModule
#'
#' @importFrom shiny NS actionButton observeEvent showModal modalDialog tagList
NULL


#' @name ResetButtonModule
resetButtonUI <- function(id, label = "Reset All"){
  ns <- NS(id)

  actionButton(ns("resetAll"), "Reset all")
}

#' @section resetButtonServer:
#' creates a secondary ui asking for confirmatio
#'
#' @rdname ResetButtonModule
resetButton <- function(input, output, session){
  observeEvent(input$resetAll, {
    showModal(modalDialog(
      tagList(
        tagList(confirmDeleteUI("confirmDelete", "Delete all points")
        )),
      title="Warning: this will delete all points currently marked",
      easyClose = TRUE,
      fade = TRUE
    ))
  })
}


#' confirmDeleteUI
#'
#' Confirmation dialog for delete
#' @rdname ResetButtonModule
confirmDeleteUI <- function(id, label = "Delete all Points"){
  ns <- NS(id)

  actionButton(ns("confirmDelete"), "Delete all points")
}


#' @name ResetButtonModule
confirmDelete <- function(input, output, session){
  observeEvent(input$confirmDelete, {
    # Resets inputs. Note this uses the rather crude measure of simply resetting the
    # page to its original state. This is used due to complexeties with resetting the
    # uploaded image - you cant use a simple `reset`
    runjs("history.go(0)")
  })
}
