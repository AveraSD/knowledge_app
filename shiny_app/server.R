#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)

# Define server logic required to draw a histogram
server=function(input, output,session) {
    # call login module supplying data frame, 
    # user and password cols and reactive trigger
    # credentials <- shinyauthr::loginServer(
    #     id = "login",
    #     data = user_base,
    #     user_col = user,
    #     pwd_col = password,
    #     log_out = reactive(logout_init())
    # )
    # 
    # # call the logout module with reactive trigger to hide/show
    # logout_init <- shinyauthr::logoutServer(
    #     id = "logout",
    #     active = reactive(credentials()$user_auth)
    # )
    session$userData$email <- 'shivani.avera@gmail.com'
    session$userData$db_trigger <- reactiveVal(0)
    callModule(
        #req(credentials()$user_auth),
        cars_table_module,
        "cars_table"
    )
        # use req to only render results when credentials()$user_auth is TRUE
        
        #restable
        #credentials()$info
   

   
}

#shinyApp(ui=ui, server=server)