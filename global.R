# global parameters and functions

Logged = FALSE;
PASSWORD <- data.frame(
    Yonghuming = c("user1", "user2", "admin1", "admin2"),
    Mima = c("03aa1a0b0375b0461c1b8f35b234e67a", # user11
             "87dc1e131a1369fdf8f1c824a6a62dff",
             "e020590f0e18cd6053d7ae0e0a507609",
             "1341215dbe9acab4361fd6417b2b11bc")
)

load_user_data <- function(user) {
    file <- paste0("./data/user/", user, ".rds")
    # create a data file as per template 
    if (!file.exists(file)) {
        template <- read_rds("./data/user/template.rds")
        write_rds(template, file)
    }
    
    
    data <- read_rds(file)     
    return(data)
}

save_user_data <- function(user, data) {
    file <- paste0("./data/user/", user, ".rds")
    write_rds(data, file) 
}

lst_cat <- list(
    Client = c("Vodafone", "TOTAL", "Orange", "Thales"),
    `Time-Off` = c("Vacation", "Sick-leave"), 
    Other = c("Other1", "Other2")
)
    
v_cat <- names(lst_cat)
