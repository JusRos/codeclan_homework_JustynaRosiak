library(shiny)
library(tidyverse)
library(bslib)

game_sales <- CodeClanData::game_sales

# Define UI for application that draws a histogram
ui <- fluidPage(

    # Application title
    titlePanel(tags$h3("Nintendo games - overview")),

    # Sidebar with a slider input for number of bins 
    
    fluidRow(
      column(width = 2),
      column(width = 4,
             radioButtons("gaming_platform",
                         tags$b(tags$i("Gaming platform")),
                        choices = c(platform))),
      column(width = 4, 
             selectInput("genre_input",
                         tags$b(tags$i("Games Genre")),
                         choices = c(genre_input))
      )
    ),
)
        # Show a plot of the generated distribution
       


# Define server logic required to draw a histogram
server <- function(input, output) {

    output$distPlot <- renderPlot({
        # generate bins based on input$bins from ui.R
        x    <- faithful[, 2]
        bins <- seq(min(x), max(x), length.out = input$bins + 1)

        # draw the histogram with the specified number of bins
        hist(x, breaks = bins, col = 'darkgray', border = 'white',
             xlab = 'Waiting time to next eruption (in mins)',
             main = 'Histogram of waiting times')
    })
}

# Run the application 
shinyApp(ui = ui, server = server)
