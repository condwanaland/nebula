#' Download Data
#'
#' UI and Server module for the download handler. Modularized so it sits apart from main app code
#'
#' @noRd
#'
downloadDataUI<- function(id, label = "Download Data"){
  ns <- NS(id)

  downloadButton(ns('downloadData'), label = "Download Data")
}


downloadData <- function(input, output, session, output_data, otolithID){
  output$downloadData <- downloadHandler(
    filename = function() {
      paste(otolithID, ".csv", sep="")
    },
    content = function(file) {
      utils::write.csv(output_data, file)
    }
  )
}
