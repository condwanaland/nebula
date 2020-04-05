#' create_image
#'
#' Takes a fileUpload and returns the image as a ggplot
#'
#' @noRd
#'
#' @importFrom ggplot2 geom_point aes
#'
create_image <- function(image, effects, click_data, point_size) {
  myplot <- magick::image_read(image)

  myplot <- apply_effects(effects, myplot)

  myplot <- magick::image_ggplot(myplot)
  myplot <- myplot + geom_point(data = click_data, aes(x = .data$x_values,
                                                       y = .data$y_values),
                                color = "blue", size = point_size)
  return(myplot)
}

