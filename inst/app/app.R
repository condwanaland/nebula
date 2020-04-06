library(shiny)
library(magick)
library(ggplot2)
library(DT)
library(shinyjs)
library(colourpicker)

# Define UI
ui <- fluidPage(

  # Application title
  titlePanel("Nebula: An Otolith Analysis Tool"),
  shinyjs::useShinyjs(),

  sidebarLayout(
    sidebarPanel(

      fileInput("current_image", "Choose image file"),
      textInput("otolithID", "Otolith ID", placeholder = "Unknown"),
      sliderInput("point_size", "Point Size", min = 1, max = 20, value = 6),
      colourpicker::colourInput("colourSelect", "Select Color", value = "blue", returnName = TRUE),
      checkboxGroupInput("effects", "Effects",
                           choices = effects_list()),

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
server <- function(input, output) {

  # Set up some necessary housekeeping
  # Create reactive dataframe to store clicks in
  click_data_reactive <- reactiveValues()
  click_data_reactive$click_data <- create_empty_df("x_values", "y_values")
  output_data <- reactive({click_data_reactive$click_data})

  # Create a table to display. output_data is in its own expression so it can be used in the
  # download handler
  output$value_table <- renderTable({
    output_data()
  })

  mydat <- observeEvent(input$current_image, {
    myplot <- magick::image_read(input$current_image$datapath)
    print(class(myplot))
    return(myplot)
  })

  print(class(mydat))




  # Handle the image output, and click observations.
  # Would like to modularise this - not sure how currently.
  output$current_image_plot <- renderPlot({
    req(input$current_image)
    myplot <- create_image(mydat(),
                          input$effects,
                          click_data_reactive$click_data,
                          input$point_size,
                          input$colourSelect)
    return(myplot)
  })


  # Observe the plot clicks
  observeEvent(input$image_click, {
    add_row <- data.frame(x_values = input$image_click$x,
                          y_values = input$image_click$y)

    click_data_reactive$click_data <- rbind(click_data_reactive$click_data, add_row)
  })

  # Observe remove button
  # observeEvent(input$delete_point, {
  #   remove_last_row(click_data_reactive)
  # })
  callModule(deletePoint,
             "delete_point",
             click_data_reactive = click_data_reactive)


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
