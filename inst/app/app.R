library(shiny)
library(magick)
library(ggplot2)
library(DT)

# Define UI
ui <- fluidPage(

  # Application title
  titlePanel("Otolith sans ggplot2"),

  sidebarLayout(
    sidebarPanel(
      fileInput("current_image", "Choose image file"),
      textInput("otolithID", "Otolith ID"),
      sliderInput("point_size", "Point Size", min = 1, max = 20, value = 12),
      actionButton("delete_point", "Delete Last Point"),
      checkboxInput("negater", "Negate"),
      downloadButton("downloadData", "Download Data")
    ),

    mainPanel(
      # TODO: use dbl click to remove?
      # How to add coloured points? If we keep storing a list of coordinates, we
      # can just add those as `points()` to the image?
      plotOutput("current_image_plot", click = "image_click"),
      tableOutput("value_table")
    )
  )
)

# Define server logic
server <- function(input, output) {

  image <- reactive({
    req(input$current_image)
    magick::image_read(input$current_image$datapath)
  })

  myplot <- reactive({
    req(input$current_image)
    if("negate" %in% input$effects)
      image <- image_negate(image)
  })

  output$current_image_plot <- renderPlot({
    req(input$current_image)
    myplot <- image_ggplot(myplot)
    myplot <- myplot + geom_point(data = values$dat, aes(x = x_values,
                                        y = y_values),
                                    color = "blue", size = input$point_size)

    return(myplot)
  })

  # Create reactive dataframe to store clicks in
  values <- reactiveValues()
  values$dat <- data.frame(x_values = numeric(),
                           y_values = numeric())

  # Observe the plot clicks
  observeEvent(input$image_click, {
    add_row <- data.frame(x_values = input$image_click$x,
                          y_values = input$image_click$y)

    values$dat <- rbind(values$dat, add_row)
  })

  # Observe remove button
  observeEvent(input$delete_point, {
    remove_row <- values$dat[-nrow(values$dat), ]
    values$dat <- remove_row
  })

  # Create a table
  output$value_table <- renderTable({
    # req(values$dat$age)
    # values$dat$age <- 1:nrow(values$dat)
    # values$dat$id <- "placeholder"
    #datatable(values$dat)
    values$dat
  })


  output$downloadData <- downloadHandler(
    filename = function() {
      paste(input$otolithID, ".csv", sep="")
    },
    content = function(file) {
      write.csv(data, file)
    }
  )

}

# Run the application
shinyApp(ui = ui, server = server)
