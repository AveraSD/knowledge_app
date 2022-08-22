#
# This is the server logic of a Shiny web application. You can run the
# 
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)

# Mention the user authrization and thr module for reading from datase in the table_generate.R file. 
shinyServer(function(input, output, session) {
  
  # call login module supplying data frame, 
  # user and password cols and reactive trigger
  credentials <- shinyauthr::loginServer(
    id = "login",
    data = user_base,
    user_col = user,
    pwd_col = password,
    sodium_hashed = TRUE,
    log_out = reactive(logout_init())
  )
  
  # call the logout module with reactive trigger to hide/show
  logout_init <- shinyauthr::logoutServer(
    id = "logout",
    active = reactive(credentials()$user_auth)
  )
  
  user_info <- reactive({
    req(credentials()$user_auth)
    as_tibble(credentials()$info)
  })
  
  #print(user_info)
  session$userData$user <- reactive({user_info()$user})
  
  
  output$testUI <- renderUI({
    req(credentials()$user_auth)
    knw_table_module_ui("db_tables")
    
    
  })
  
  # Call the server function portion of the `cars_table_module.R` module file
  callModule(
    cars_table_module,
    "db_tables"
  )
  
  
  
})
