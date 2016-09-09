# the main UI to display once user passed authentification
observe({
    if (USER$Logged == TRUE) {
        output$sideui <- renderUI({
            div(
                wellPanel(
                    textOutput("text_1"),
                    br(),
                    dateInput("dat", "Select a Date", 
                              min = "2016-01-01", 
                              max = "2016-12-12"),
                    selectInput("slc_cat", "Category", 
                                choices = v_cat),
                    selectInput("slc_subcat", "Sub-category", 
                                choices = NULL),
                    numericInput("num_hr", "Hours", value = 1,
                                 min = 0, max = 12, step = 0.5),
                    actionButton("btn_add", "Log my hours", icon = icon("pencil")),
                    actionButton("btn_savedb", "Submit", icon = icon("save"))
                    
                    # div(
                    #     style = "display:inline-block",
                    #     downloadButton('downloadData', 'Download(.csv)')
                    # )
                ),
                
                conditionalPanel(condition = "output.admin",
                    wellPanel(
                        h4("Admin module"),
                        downloadButton("dlbtn_1", "Download all data")
                    )

                )
            )


        })
        
        output$mainui <- renderUI({
            DT::dataTableOutput("DT_1")
        })
    }
})