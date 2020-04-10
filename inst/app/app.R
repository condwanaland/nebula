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
                           choices = effects_list())
        ),

      resetButtonUI("resetAll", "Reset All"),
      downloadDataUI("downloadData", "Download Data")
    ),

    mainPanel(
      plotOutput("current_image_plot", click = "image_click"),
      deletePointUI("delete_point", "Delete Point"),
      tableOutput("value_table")
    )
  )
)

# Define server logic
server <- function(input, output, session) {

  # Create a reactive dataframe to store plot clicks in
  click_data_reactive <- shiny::reactiveValues()
  click_data_reactive$click_data <- create_empty_df("x_values", "y_values")
  output_data <- shiny::reactive({click_data_reactive$click_data})


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
                          click_data_reactive$click_data,
                          input$point_size,
                          input$colourSelect)
    return(displayed_image)
  })


  # Observe the plot clicks
  observeEvent(input$image_click, {
    add_row <- data.frame(x_values = input$image_click$x,
                          y_values = input$image_click$y)

    click_data_reactive$click_data <- rbind(click_data_reactive$click_data, add_row)
  })

  observeEvent(input$current_image, {
    updateTextInputWithFileName(input$current_image$name, session)
  })

  # Observe remove button
  callModule(deletePoint,
             "delete_point",
             click_data_reactive = click_data_reactive)


  # Handle the reset all modal. This is done in a 2-pass manner The first module starts a
  # modal with a 'confirm' button. The confirm button then triggers the app reset.
  callModule(resetButton, "resetAll")
  callModule(confirmDelete, "confirmDelete", click_data_rm = click_data_reactive$click_data)

  # Data download module
  callModule(downloadData, id = "downloadData",
             output_data = output_data(),
             otolithID = input$otolithID)

}

# Run the application
shinyApp(ui = ui, server = server)
