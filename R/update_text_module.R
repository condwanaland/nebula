#' updateTextInputWithFileName
#'
#' This function is located inside an observeEvent. When a file upload is done, it cleans the file path and updates the otolithID text input with the filename.
#'
#' @param input_path The 'name' field of the file upload
#' @param session Shinys session argument
#'
#' @keywords internal
#' @noRd
updateTextInputWithFileName <- function(input_path, session){
    input_file_name <- input_path
    input_file_name <- tools::file_path_sans_ext(input_file_name)
    updateTextInput(session, inputId = "otolithID", value = input_file_name)
}



