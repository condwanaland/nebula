#' show_click
#'
#' Process the plot single click and stores in dataframe. Used within an observeEvent
#'
#' @param click_data Reactive dataframe with x and y values
#' @param x_val Plot input for single click interaction x values
#' @param y_val Plot input for single click interaction y values
#'
#' @keywords internal
show_click <- function(click_data, x_val, y_val) {
  add_row <- data.frame(x_values = x_val,
                        y_values = y_val)

  click_data$click <- rbind(click_data$click, add_row)
}


#' show_transect
#'
#' Processes the plots double click and hover inputs to create a transect line. Used within an observeEvent
#'
#' @param transect_dat Reactive dataframe holding x and y values
#' @param x_val Plot input for double click interaction x values
#' @param y_val Plot input for double click interaction y values
#' @param input_ Placeholder parameter to pass the `input$hover` from enclosing env
#'
#' @keywords internal
show_transect <- function(transect_dat, x_val, y_val, input_){
  clickrow <- data.frame(x_values = x_val,
                         y_values = y_val)

  if(transect_dat$n < 3){
    transect_dat$double_click[transect_dat$n, ] <- clickrow
  }

  transect_dat$n <- transect_dat$n + 1

  new_hov<-reactive(
    input_$hover
  )  %>% debounce(millis = 150)

  observeEvent(new_hov(), {
    nh <- new_hov()
    hoverrow <- data.frame(x_values = nh$x,
                           y_values = nh$y)

    if (transect_dat$n < 3){
      transect_dat$double_click[transect_dat$n, ] <- hoverrow
    }

  })
}
