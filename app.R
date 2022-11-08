#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(tidyverse)

drinks <- readr::read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2020/2020-05-26/cocktails.csv')
boston_drinks <- readr::read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2020/2020-05-26/boston_cocktails.csv')


# Define UI for application that draws a histogram
ui <- fluidPage(

    # Application title
    titlePanel("Cocktail Data"),

    # Sidebar with a slider input for number of bins 
    sidebarLayout(
        sidebarPanel(
          selectInput("ingredient", "Ingredient", choices = sort(unique(drinks$ingredient)), selected = "Creme de Cacao"),
        ),

        mainPanel(
           tableOutput("dist")
        )
    )
)

server <- function(input, output) {
  
  drk_subset <- reactive({
    drinks %>%
      filter(ingredient == input$ingredient)
  })

    output$dist <- renderTable({
        drk_subset() %>%
        select(drink, category, glass)

    })
}

# Run the application 
shinyApp(ui = ui, server = server)
