# app Transliterator with simple user authentication 
library(shiny)
Logged = FALSE;
PASSWORD <- data.frame(Yonghuming = "sgdna", 
                       Mima = "25d55ad283aa400af464c76d713c07ad")


# non-English character translator app - transliterator

library(dplyr)
library(shinythemes)
library(readr)
library(openxlsx)

translateV <- function(vec){
    if (class(vec) == 'character'){
        out <- iconv(vec, to = "ASCII//TRANSLIT")
    } else {
        out <- vec
    }
    
    return(out)
}

translateDF <- function(df){
    df %>% 
        lapply(translateV) %>% 
        as.data.frame(stringsAsFactors = F)
}


ui <- fluidPage(theme = shinytheme("united"),
  # Add custom CSS & Javascript;
  tagList(
    tags$head(
      tags$link(rel = "stylesheet", type = "text/css", href = "style.css"),
      tags$script(type = "text/javascript", src = "md5.js"),
      tags$script(type = "text/javascript", src = "passwdInputBinding.js")
    )
  ),
  
  titlePanel("Non-English Character Transliterator"),
  ## Login module;
  div(class = "login",
      uiOutput("uiLogin"),
      textOutput("pass")
  ), 
  div(class = "row",
      div(class = "col-md-3", uiOutput("sideui")),
      div(class = "col-md-9", uiOutput("mainui"))
  )

  
)


# Define server logic required to summarize and view the selected dataset
server <- function(input, output, session) {
  source("www/Login.R",  local = TRUE)
  
  observe({
    if (USER$Logged == TRUE) {
      output$sideui <- renderUI({
        wellPanel(
            h4("What is this app for"),
            p("This app allows user to",
            a(href = "https://en.wikipedia.org/wiki/Transliteration",
              target="_blank", "transliterate"), 
            " non-English characters into their English 
            equivalent(ASCII codes)."),
            
            hr(),
            
            h4("Step 1 : Upload a file containing non-English characters"),
            a(href="http://10.196.101.22:3838/docs/sampleInput/sampleNonASCII.xlsx",
            target = "_blank", "sample file"),
            
            fileInput("file1", label = "Upload file (.xlsx)",
                    accept = c('.xls', '.xlsx')),
            
            h4("Step 2 : Get transliterated results in ASCII codes "),
            
            div(style="display:inline-block",     
              downloadButton('downloadData', 'Download(.csv)'))
        )
      })
      
      output$mainui <- renderUI({
        div(
            column(width = 6,  
                   h3('Input Preview (first 50 rows)'), br(),
                   textOutput('txtInput1'),
                   tableOutput('tblInput1')     
            ),
            
            column(width = 6,
                   h3('Output Preview (first 50 rows)'), br(),
                   textOutput('txtOutput'),
                   tableOutput('tblOutput')     
            ),
            
            br()
        )
      })
    }
  })
  
  # read hotel id file
  dfOrig <- reactive({
      req(input$file1)
      path1 <- input$file1$datapath 
      out <- read.xlsx(path1, colNames = T)
      
      # fill NA with empty strings
      out[is.na(out)] <-""
      return(out)
  })
  
  # preview input data
  
  output$txtInput1 <- renderText({
      req(dfOrig())
      paste0(nrow(dfOrig()), " rows, ", ncol(dfOrig()), " columns")
  })
  
  output$tblInput1 <- renderTable({
      req(dfOrig())
      dfOrig() %>%  
          head(50)
  })
  
  dfTrans <- reactive({
      dfOrig() %>% translateDF() 
      
  })
  
  
  # preview output
  output$txtOutput <- renderText({
      req(dfTrans())
      paste0(nrow(dfTrans()), " rows, ", ncol(dfTrans()), " columns")
  })
  
  output$tblOutput <- renderTable({
      req(dfTrans())
      head(dfTrans(), 50)
  })
  
  
  # download
  output$downloadData <- downloadHandler(
      filename = function() { 
          paste('output', '.csv', sep='') 
      },
      content = function(file) {
          write_csv(dfTrans(), file)
      }
  )
  
}

shinyApp(ui, server)