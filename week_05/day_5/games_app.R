library(shiny)
library(tidyverse)
library(DT)

games <- CodeClanData::game_sales


ui <- 
  fluidPage(
   
    titlePanel("Games Sales overview"),
     # total sales plot in the first row
    fluidRow(column(2),
             column(8,
      plotOutput("gamestotal_plot"),
      column(2)
    )),
    # adding slider 
    fluidRow(
      column(2,
        sliderInput("year_of_release", label = h2("Year"), min = 1996,
                    max = 2016, value = 1,
                    step = 1,
                    width = "70%", # Adjust the width of the slider
                    sep = "", # Remove the separator between the handles
                    ticks = TRUE # keep tick marks from the slider
        )),
    # adding two other plots
      column(4,
            plotOutput("platforms_plot")),
      column(4,
           plotOutput("genre_plot"),
      column(1))
    
  ))

 

server <- function(input, output, session) {
  # first plot output
  output$gamestotal_plot <- renderPlot({
    games %>% filter(between(year_of_release, 1996, 2016)) %>% group_by(year_of_release) %>% summarise(total_sales = sum(sales)) %>% 
      ggplot()+
      aes(x = year_of_release, y = total_sales)+
      geom_line(size = 1.5, colour = "navy")+
      labs(
        title = "\n Game Sales from 1996 to 2016\n",
        x = "\nYear\n", 
        y = "\nSales (mln)\n"
      )+
      theme(
        text = element_text(size = 12),
        title = element_text(size = 14, face = "bold"),
        axis.text = element_text(size = 12),
        panel.background = element_rect((fill = "white")),
        panel.grid = element_line(colour = "grey", linetype = "dotted")
      )
  }
    
  )
  # second plot output
  output$platforms_plot <- renderPlot({
    games %>% filter(year_of_release == input$year_of_release) %>% group_by(platform) %>% summarise(total_sales = sum(sales)) %>% head(n = 5) %>% 
      ggplot()+
      aes(x = total_sales, y = platform)+
      geom_col(fill = "navyblue")+
      geom_text(aes(label = ifelse(total_sales > 1, total_sales, " ")),
                colour = "white", size = 5, hjust = 1.3
                
      )+
      labs(
        title = "\nTop 5 Game Platforms by Sales in the chosen Year\n",
        x = "\nTotal Sales (mln)\n", 
        y = "\nPlatform\n"
      )+
      theme(
        text = element_text(size = 12),
        title = element_text(size = 14, face = "bold"),
        axis.text = element_text(size = 12),
        panel.background = element_rect((fill = "white")),
        panel.grid = element_line(colour = "grey", linetype = "dotted")
      )
    
    }
  )
  # third plot output
  output$genre_plot <- renderPlot({
    games %>%  filter(year_of_release == input$year_of_release) %>% group_by(genre) %>% summarise(total_sales = sum(sales)) %>% arrange(desc(total_sales)) %>% head(n = 5) %>% 
      ggplot()+
      aes(x = total_sales, y = genre)+
      geom_col(fill = "navy")+
      geom_text(aes(label = ifelse(total_sales > 1, total_sales, " ")),
                colour = "white", size = 5, hjust = 1.2)+
      labs(
        title = "\nTop 5 Game Genres by Sales in the chosen Year\n",
        x = "\nTotal Sales (mln)\n", 
        y = "\nGenre\n"
      )+
      theme(
        text = element_text(size = 12),
        title = element_text(size = 14, face = "bold"),
        axis.text = element_text(size = 12),
        panel.background = element_rect((fill = "white")),
        panel.grid = element_line(colour = "grey", linetype = "dotted")
      )
    
    
    
  })

  
}

shinyApp(ui, server)