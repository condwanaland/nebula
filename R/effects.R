#' apply_effects
#'
#' Takes a shiny input and applies `magick` filters based on those inputs
#'
#' @param inputs A list of valid `magick` effects
#' @param image A object returned by `magick::image_read`
#'
#' @return A pointer to a 'magick-image' object
#' @keywords internal
#'
apply_effects <- function(inputs, image){
  if("negate" %in% inputs){
    image <- image_negate(image)
  }

  if("charcoal" %in% inputs){
    image <- image_charcoal(image)
  }

  if("edge" %in% inputs){
    image <- image_edge(image)
  }

  if("despeckle" %in% inputs){
    image <- image_despeckle(image)
  }

  if("reduce_noise" %in% inputs){
    image <- image_reducenoise(image)
  }
  return(image)
}


#' effects_list
#'
#' List of available image effects
#'
#' @return List of elements
#' @keywords internal
effects_list <- function(){
  effects_list <- list("negate", "charcoal", "edge", "despeckle", "reduce_noise")
  return(effects_list)
}
