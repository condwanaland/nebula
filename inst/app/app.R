library(shiny)
library(magick)
library(ggplot2)
library(DT)
library(shinyjs)
library(colourpicker)
library(shinyWidgets)
library(nebula)


# Define UI
ui <- fluidPage(

  # Application title
  titlePanel("Nebula: An Otolith Analysis Tool"),
  shinyjs::useShinyjs(),

  sidebarLayout(
    sidebarPanel(

      fileInput("current_image", "Choose image file"),
      textInput("otolithID", "Otolith ID", placeholder = "Unknown"),
      dropdownButton(
        tags$h3("Plot Options"),
        sliderInput("point_size", "Point Size", min = 1, max = 20, value = 6),
        colourpicker::colourInput("colourSelect", "Select Color",
                                  value = "blue", palette = "limited"),
        checkboxGroupInput("effects", "Effects",
                           choices = effects_list()),
        sliderInput("transect_point_size", "Transect Point Size", min = 1, max = 20, value = 4),
        sliderInput("transect_line_size", "Transect Point Size", min = 1, max = 20, value = 4),
        colourpicker::colourInput("transect_color", "Select Transect Color",
                                  value = "green", palette = "limited")
        ),

      resetButtonUI("resetAll", "Reset All"),
      downloadDataUI("downloadData", "Download Data")
    ),

    mainPanel(
      plotOutput("current_image_plot",
                 click = "image_click",
                 dblclick = "double_click",
                 hover = "hover"
                 ),
      deletePointUI("delete_point", "Delete Point"),
      tableOutput("value_table")
    )
  )
)

# Define server logic
server <- function(input, output, session) {

  # Load data structures for storing plot interactions
  source("global.R", local = TRUE)

  # Create a table to display. output_data is in its own expression so it can be used in the
  # download handler
  output$value_table <- renderTable({
    output_data()
  })

  # Read the uploaded image
  loaded_image <- eventReactive(input$current_image, {
    magick::image_read(input$current_image$datapath)
  })

  # Handle the image output, and click observations.
  # Would like to modularise this - not sure how currently.
  output$current_image_plot <- renderPlot({
    req(input$current_image)
    displayed_image <- create_image(loaded_image(),
                          input$effects,
                          click_data$click,
                          transect_data$double_click,
                          input$point_size,
                          input$colourSelect,
                          input$transect_point_size,
                          input$transect_line_size,
                          input$transect_color)
    return(displayed_image)
  })

  # Observe the plot clicks
  observeEvent(input$image_click, {
    show_click(click_data, input$image_click$x, input$image_click$y)
  })

  observeEvent({input$double_click}, {
    show_transect(transect_data, input$double_click$x, input$double_click$y, input)
  })

  # Update the image id with its filename - used to provide a csv name when downloading
  observeEvent(input$current_image, {
    updateTextInputWithFileName(input$current_image$name, session)
  })

  # Observe remove button
  callModule(deletePoint,
             "delete_point",
             click_data = click_data)


  # Handle the reset all modal. This is done in a 2-pass manner The first module starts a
  # modal with a 'confirm' button. The confirm button then triggers the app reset.
  callModule(resetButton, "resetAll")
  callModule(confirmDelete, "confirmDelete")

  # Data download module
  callModule(downloadData, id = "downloadData",
             output_data = output_data(),
             otolithID = input$otolithID)

}

# Run the application
shinyApp(ui = ui, server = server)
