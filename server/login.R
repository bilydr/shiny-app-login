#### Log in module ###
USER <- reactiveValues(Logged = Logged, username = NULL)

passwdInput <- function(inputId, label) {
    tagList(tags$label(label),
            tags$input(
                id = inputId,
                type = "password",
                value = ""
            ))
}


# login screen UI----
output$uiLogin <- renderUI({
    # only visible when not logged in
    if (USER$Logged == FALSE) {

        wellPanel(
            textInput("userName", "UserID:"),
            p(strong("Password:")),
            passwdInput("passwd", ""),
            br(),
            br(),
            actionButton("Login", "Log in")
        )
    }
})

output$pass <- renderText({
    # only visible when not logged in
    if (USER$Logged == FALSE) {
        if (!is.null(input$Login)) {
            if (input$Login > 0) {
                Username <- isolate(input$userName)
                
                Password <- isolate(input$passwd)
                Id.username <- which(PASSWORD$Yonghuming == Username)
                Id.password <- which(PASSWORD$Mima == Password)
            
                if (length(Id.username) > 0 & length(Id.password) > 0) {
                    if (Id.username == Id.password) {
                        # actions inside a reactive - to refactor
                        USER$ID <- Username
                        USER$Logged <- TRUE
                    }
                } else  {
                    "UserID or password incorrect!"
                }
            }
        }
    }
})
