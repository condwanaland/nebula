#' run_app
#'
#' Starts the Otolith analysis app in your web browser
#'
#' @export
#'
#' @examples
#' \dontrun{
#' nebula()
#' }
nebula <- function(){
  appDir <- system.file("app", "app.R", package = "nebula")
  if (appDir == "") {
    stop("Could not find example directory. Try re-installing `nebula`.", call. = FALSE)
  }

  shiny::runApp(appDir, display.mode = "normal", launch.browser = TRUE)
}
