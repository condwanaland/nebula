library(shiny)
library(magick)
library(ggplot2)

# Define UI for application that draws a histogram
ui <- fluidPage(

  # Application title
  titlePanel("Otolith sans ggplot2"),

  # Sidebar with a slider input for number of bins
  sidebarLayout(
    sidebarPanel(
      fileInput("current_image", "Choose image file")
    ),

    # Show a plot of the generated distribution
    mainPanel(
      imageOutput("current_image_plot")
    )
  )
)

# Define server logic required to draw a histogram
server <- function(input, output) {

  output$current_image_plot <- renderImage({

    req(input$current_image)

    image <- magick::image_read(input$current_image$datapath)

    tmpfile <- image %>%
      image_write(tempfile(), format = 'png')


    return(list(src = tmpfile, contentType = "image/png"))
  })

}

# Run the application
shinyApp(ui = ui, server = server)
