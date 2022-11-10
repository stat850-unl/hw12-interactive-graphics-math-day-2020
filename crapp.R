#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(shinythemes)
library(tidyverse)

drinks <- readr::read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2020/2020-05-26/cocktails.csv')
boston_drinks <- readr::read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2020/2020-05-26/boston_cocktails.csv')


# Define UI for application that draws a histogram
ui <- fluidPage(theme=shinytheme('yeti'),
                navbarPage(
                  theme='yeti',
                  'Pour Me Another One',
                  tabPanel('Adult Drinks',
                           sidebarLayout(
                             sidebarPanel(
                               selectInput("ad_drink_name", "Drink Name", choices = sort(unique(drinks$drink)), selected = "'57 Chevy with a White License Plate")
                             ),
                             mainPanel(
                               tableOutput("alc_list")
                             )
                           )
                  ),
                  tabPanel('Kid-Friendly',
                           sidebarLayout(
                             sidebarPanel(selectInput("kid_drink_name", "Drink Name", choices = sort(unique(filter(drinks,alcoholic=='Optional alcohol'|alcoholic=='Non alcoholic')$drink)), selected = "Afterglow")
                            ),
                            mainPanel(
                              tableOutput('kid_list')
                            )
                             )
                           )
                )
)


server <- function(input, output) {
  
  alc_subset <- reactive({
    drinks %>%
      filter(drink == input$ad_drink_name)
  })
  
  kid_subset <- reactive({
    drinks %>% filter(drink==input$kid_drink_name)
  })
  
  output$alc_list <- renderTable({
    alc_subset() %>%
      select(ingredient, glass, category)
    
  })
  output$kid_list <- renderTable({
    kid_subset() %>%
      select(ingredient, glass, category, alcoholic)
    
  })
  
}

# Run the application 
shinyApp(ui = ui, server = server)
