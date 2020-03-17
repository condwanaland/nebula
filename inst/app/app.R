library(shiny)
library(magick)
library(ggplot2)
library(DT)
library(nebula)

# Define UI
ui <- fluidPage(

  # Application title
  titlePanel("Nebula: An Otolith Analysis Tool"),

  sidebarLayout(
    sidebarPanel(
      fileInput("current_image", "Choose image file"),
      textInput("otolithID", "Otolith ID"),
      sliderInput("point_size", "Point Size", min = 1, max = 20, value = 12),
      actionButton("delete_point", "Delete Last Point"),
      checkboxGroupInput("effects", "Effects",
                         choices = list("negate", "charcoal", "edge")),
      downloadButton("downloadData", "Download Data")
    ),

    mainPanel(
      plotOutput("current_image_plot", click = "image_click"),
      tableOutput("value_table")
    )
  )
)

# Define server logic
server <- function(input, output) {


  output$current_image_plot <- renderPlot({
    req(input$current_image)
    myplot <- magick::image_read(input$current_image$datapath)
    if("negate" %in% input$effects){
      myplot <- image_negate(myplot)
    }

    if("charcoal" %in% input$effects){
      myplot <- image_charcoal(myplot)
    }

    if("edge" %in% input$effects){
      myplot <- image_edge(myplot)
    }

    myplot <- image_ggplot(myplot)
    myplot <- myplot + geom_point(data = click_data_reactive$click_data, aes(x = x_values,
                                        y = y_values),
                                    color = "blue", size = input$point_size)

    return(myplot)
  })

  # Create reactive dataframe to store clicks in
  click_data_reactive <- reactiveValues()
  click_data_reactive$click_data <- data.frame(x_values = numeric(),
                                               y_values = numeric())

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

  # Create a table
  output$value_table <- renderTable({
    # req(values$dat$age)
    # values$dat$age <- 1:nrow(values$dat)
    # values$dat$id <- "placeholder"
    #datatable(values$dat)
    click_data_reactive$click_data
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
