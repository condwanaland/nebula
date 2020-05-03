#' create_image
#'
#' Takes a fileUpload and returns the image as a ggplot
#'
#' @noRd
#'
#' @importFrom ggplot2 geom_point aes
#'
create_image <- function(loaded_image, effects, click_data, click_data2, point_size, colour_select) {

  displayed_image <- apply_effects(effects, loaded_image)
  displayed_image <- magick::image_ggplot(displayed_image)
  displayed_image <- displayed_image +
    geom_point(data = click_data, aes(x = .data$x_values,
                                      y = .data$y_values),
               color = colour_select,
               size = point_size) +
    geom_path(data = click_data2, aes(x = .data$x_values,
                                      y = .data$y_values
                                      ),
               color = "yellow")
  return(displayed_image)
}

