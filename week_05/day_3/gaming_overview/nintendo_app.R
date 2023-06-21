library(shiny)
library(tidyverse)
library(bslib)

game_sales <- CodeClanData::game_sales
year_input <- game_sales %>% distinct(year_of_release) %>% arrange(year_of_release) %>% pull()
game_publisher <- game_sales %>% distinct(publisher) %>% arrange(publisher) %>% pull()


ui <- fluidPage(

    # Application title
    titlePanel(tags$h3("Nintendo games - overview")),
    
   plotOutput("game_publishing_plot"),
   
    fluidRow(
      column(width = 2),
      column(width = 4,
             radioButtons("publisher_input",
                         tags$b(tags$i("Games publisher")),
                        choices = c(game_publisher))),
      column(width = 4, 
             selectInput("year_input",
                         tags$b(tags$i("Year of release")),
                         choices = c(year_input))
      )
    ),
)


   
# Define server logic required to draw a histogram
server <- function(input, output){

    output$game_publishing_plot <- renderPlot({
      game_sales %>% filter(publisher == input$publisher_input) %>%
        filter(year_of_release == input$year_input) %>% 
        ggplot(aes(x = factor(year_of_release), fill = platform))+
        geom_bar(position = "dodge", show.legend = TRUE)+
        labs(
          x = "\nYear of release\n",
          y = "\nCount\n"
        ) + 
       theme(axis.text = element_text(size = 8, face = "plain"))})

}
# Run the application 
shinyApp(ui = ui, server = server)
