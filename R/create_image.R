create_image <- function(image, effects, click_data, point_size) {
  myplot <- magick::image_read(image)

  myplot <- apply_effects(effects, myplot)

  myplot <- magick::image_ggplot(myplot)
  myplot <- myplot + geom_point(data = click_data, aes(x = x_values,
                                                       y = y_values),
                                color = "blue", size = point_size)
  return(myplot)
}

