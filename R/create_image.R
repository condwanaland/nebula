#' create_image
#'
#' Takes a fileUpload and returns the image as a ggplot
#'
#' @noRd
#'
#' @importFrom ggplot2 geom_point aes geom_path
#'
create_image <- function(loaded_image,
                         effects,
                         click_data,
                         transect_data,
                         point_size,
                         point_colour,
                         transect_point_size,
                         transect_line_size,
                         transect_color) {

  displayed_image <- apply_effects(effects, loaded_image)
  displayed_image <- magick::image_ggplot(displayed_image)
  displayed_image <- displayed_image +
    geom_point(data = click_data, aes(x = .data$x_values,
                                      y = .data$y_values),
               color = point_colour,
               size = point_size) +
    geom_path(data = transect_data, aes(x = .data$x_values,
                                      y = .data$y_values
                                      ),
               color = transect_color,
               size = transect_line_size, na.rm = TRUE) +
    geom_point(data = transect_data, aes(x = .data$x_values,
                                         y = .data$y_values
                                         ),
               color = transect_color,
               size = transect_point_size)
  return(displayed_image)
}

