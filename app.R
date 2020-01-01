library(shiny)
library(magick)
library(ggplot2)

# Define UI for application that draws a histogram
ui <- fluidPage(

   # Application title
   titlePanel("Otolith"),

   # Sidebar with a slider input for number of bins
   sidebarLayout(
      sidebarPanel(
        fileInput("current_image", "Choose image file")
      ),

      # Show a plot of the generated distribution
      mainPanel(
        plotOutput("current_image_plot")
      )
   )
)

# Define server logic required to draw a histogram
server <- function(input, output) {

  output$current_image_plot <- renderPlot({

    req(input$current_image)

    dat <- magick::image_read(input$current_image$datapath)
    myplot <- magick::image_ggplot(dat)

    return(myplot)
  })

}

# Run the application
shinyApp(ui = ui, server = server)
