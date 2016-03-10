# sample app of simple shiny authentification
library(shiny)
library(datasets)
Logged = FALSE;
PASSWORD <- data.frame(Yonghuming = "sgdna", 
                       Mima = "25d55ad283aa400af464c76d713c07ad")


ui <- bootstrapPage(
  # Add custom CSS & Javascript;
  tagList(
    tags$head(
      tags$link(rel = "stylesheet", type = "text/css", href = "style.css"),
      tags$script(type = "text/javascript", src = "md5.js"),
      tags$script(type = "text/javascript", src = "passwdInputBinding.js")
    )
  ),
  
  ## Login module;
  div(class = "login",
      uiOutput("uiLogin"),
      textOutput("pass")
  ), 
  
  div(class = "span4", uiOutput("obs")),
  div(class = "span8", plotOutput("distPlot"))
  
)


# Define server logic required to summarize and view the selected dataset
server <- function(input, output, session) {
  source("www/Login.R",  local = TRUE)
  
  observe({
    if (USER$Logged == TRUE) {
      output$obs <- renderUI({
        sliderInput("obs", "Number of observations:", 
                    min = 10000, max = 90000, 
                    value = 50000, step = 10000)
      })
      
      output$distPlot <- renderPlot({
        dist <- NULL
        # browser()
        dist <- rnorm(input$obs)
        hist(dist, breaks = 100, main = paste("Your password:", input$passwd))
      })
    }
  })
}

shinyApp(ui, server)