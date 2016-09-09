# time tracking mock up
library(shiny)
library(dplyr)
library(shinythemes)
library(readr)
library(DT)
options(shiny.error = browser) # browser or recover or NULL

source("global.R")

ui <- fluidPage(
    theme = shinytheme("readable"),
    # Add custom CSS & Javascript;
    tagList(tags$head(
        tags$link(rel = "stylesheet", type = "text/css", href = "style.css"),
        tags$script(type = "text/javascript", src = "md5.js"),
        tags$script(type = "text/javascript", src = "passwdInputBinding.js")
    )),
    
    titlePanel("SG EMEA Time Tracking Mock-up"),
    ## Login module;
    div(class = "login",
        uiOutput("uiLogin"),
        textOutput("pass")),
    div(
        class = "row",
        div(class = "col-md-3", uiOutput("sideui")),
        div(class = "col-md-9", uiOutput("mainui"))
    )
)


# Define server logic required to summarize and view the selected dataset
server <- function(input, output, session) {
    
    # condition flag for conditional panel reserved for admin users
    output$admin <- reactive({
        grepl("admin", USER$ID)
    })
    outputOptions(output, 'admin', suspendWhenHidden = FALSE)
    
    source("server/login.R",  local = TRUE)$value
    source("server/main_ui.R",  local = TRUE)$value
 
    DATA <- reactiveValues()
    
    # initalize data
    observe({
        req(USER$ID)
        DATA$current <- load_user_data(USER$ID)    
    })
    
    # welcome message
    output$text_1 <- renderText(
        paste("Welcome,", USER$ID)
    )
    
    # write new entries to memory
    observeEvent(input$btn_add, {
        data <- DATA$current
        new_record <- data_frame(
            Date = input$dat,
            Category = input$slc_cat,
            Subcat = input$slc_subcat,
            Hours = input$num_hr)
        data <- bind_rows(data, new_record)
        DATA$current <- data
    })
    
    # update dependent list of sub-category
    observeEvent(input$slc_cat, {
        updateSelectInput(session, "slc_subcat", choices = lst_cat[[input$slc_cat]] )
    })
    
    # display user data in memory
    output$DT_1 <- DT::renderDataTable({
        DATA$current
    })

    # save user data to database
    observeEvent(input$btn_savedb,{
        save_user_data(USER$ID, DATA$current)
    })
    
}

shinyApp(ui, server)