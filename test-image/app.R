library(shiny)
library(magick)

ui <- fluidPage(


   titlePanel(""),


   sidebarLayout(
      sidebarPanel(
        fileInput("current_image", "Choose image file")),


      mainPanel(
        plotOutput("current_image_plot")
      )
   )
)


server <- function(input, output) {

  output$current_image_plot <- renderPlot({
    req(input$current_image)
    myplot <- magick::image_read(input$current_image$datapath)
    myplot <- image_ggplot(myplot)
    return(myplot)
})
}

shinyApp(ui = ui, server = server)

