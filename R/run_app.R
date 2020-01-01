#' run_app
#'
#' Starts the Otolith analysis app in your web browser
#'
#' @export
#'
#' @examples
#' \dontrun{
#' otolithr::run_app()
#' }
run_app <- function(){
  appDir <- system.file("app", "app.R", package = "otolithr")
  if (appDir == "") {
    stop("Could not find example directory. Try re-installing `otolithr`.", call. = FALSE)
  }

  shiny::runApp(appDir, display.mode = "normal")
}
