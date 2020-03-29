library(shiny)
library(magick)
library(ggplot2)
library(DT)
library(shinyjs)

# Define UI
ui <- fluidPage(

  # Application title
  titlePanel("Nebula: An Otolith Analysis Tool"),
  shinyjs::useShinyjs(),

  sidebarLayout(
    sidebarPanel(
      # Add div for these inputs so state can be reset on all of them
      div(
        id = 'state',
        fileInput("current_image", "Choose image file"),
        textInput("otolithID", "Otolith ID", placeholder = "Unknown"),
        sliderInput("point_size", "Point Size", min = 1, max = 20, value = 6),
        checkboxGroupInput("effects", "Effects",
                           choices = effects_list())
      ),
      actionButton("resetAll", "Reset all"),
      downloadButton("downloadData", "Download Data")
    ),

    mainPanel(
      plotOutput("current_image_plot", click = "image_click"),
      actionButton("delete_point", "Delete Last Point"),
      tableOutput("value_table")
    )
  )
)

# Define server logic
server <- function(input, output) {


  output$current_image_plot <- renderPlot({
    req(input$current_image)
    myplot <- magick::image_read(input$current_image$datapath)

    myplot <- apply_effects(input$effects, myplot)

    myplot <- image_ggplot(myplot)
    myplot <- myplot + geom_point(data = click_data_reactive$click_data, aes(x = x_values,
                                                                             y = y_values),
                                  color = "blue", size = input$point_size)
    return(myplot)
  })

  # Create reactive dataframe to store clicks in
  click_data_reactive <- reactiveValues()
  click_data_reactive$click_data <- create_empty_df(x_values, y_values)


  # Observe the plot clicks
  observeEvent(input$image_click, {
    add_row <- data.frame(x_values = input$image_click$x,
                          y_values = input$image_click$y)

    click_data_reactive$click_data <- rbind(click_data_reactive$click_data, add_row)
  })

  # Observe remove button
  observeEvent(input$delete_point, {
    remove_last_row(click_data_reactive)
  })



  observeEvent(input$resetAll, {
    showModal(modalDialog(
      tagList(
        tagList(actionButton("confirmDelete", "Delete all points")
      )),
      title="Warning: this will delete all points currently marked",
      easyClose = TRUE,
      fade = TRUE
    ))
  })


  observeEvent(input$confirmDelete, {
    # Resets inputs
    shinyjs::reset("state")

    # Resets click_data_reactive
    click_data_reactive$click_data <- click_data_reactive$click_data[c(), ]
    removeModal()

    # How to reset image?
  })


  # Create a table to display. output_data is in its own expression so it can be used in the
  # download handler
  output_data <- reactive({click_data_reactive$click_data})

  output$value_table <- renderTable({
    output_data()
  })


  output$downloadData <- downloadHandler(
    filename = function() {
      paste(input$otolithID, ".csv", sep="")
    },
    content = function(file) {
      write.csv(output_data(), file)
    }
  )

}

# Run the application
shinyApp(ui = ui, server = server)
