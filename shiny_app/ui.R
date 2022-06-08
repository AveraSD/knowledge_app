#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)

# Define UI for application that draws a histogram
ui = dashboardPage(skin = "green",
                             title="Avera Knowledge Form",
                             dashboardHeader(
                                 title = span("Knowledge Base",style ='font-size: 20px; font-weight: bold;')
                                 # tags$li(class = "dropdown",div(style="display:inline-block;padding-top:10px;padding-right:80px",
                                 #                                actionButton("done", " Save",icon = icon("fas fa-file-download"),
                                 #                                             style = 'width:150%;border-color:#FF7A00;border-width:2px;color:red;' )))
                             ),
                   dashboardSidebar(
                       collapsed = TRUE,
                       br(),
                       helpText("Add in the format matching to the dropdown menu; RETURN TO NONE ONCE DONE"),
                       textInput("nameSearch", "Add New Values"),
                       br(),
                       radioGroupButtons(
                           inputId = "Id072",
                           label = "Push Into",
                           choices = c("None"='ad7',"Gene"='ad1', 
                                       "Variant"='ad2', "Tumor"='ad3',"Drugs"='ad4', "Durg Full Name"='ad5',"Durg Family"='ad6'),
                           status = "danger",
                           selected = 'ad7',
                           direction = "vertical",
                           checkIcon = list(
                               yes = icon("ok", 
                                          lib = "glyphicon"),
                               no = icon("remove",
                                         lib = "glyphicon"))
                       )
                   ),
                   dashboardBody(navbarPage("", 
                                              theme =shinytheme("paper"),
                                              tabPanel("DATA TABLE",
                                                       cars_table_module_ui("cars_table")
                                                       
                                              ),
                                              tabPanel("ADD DATA"
                                                       #cars_table_module_ui("cars_table")
                                                       
                                              )
                   )
                   )
                                              
    # add logout button UI
   # shinyauthr::logoutUI(id = "logout"),
    # add login panel UI function
   # shinyauthr::loginUI(id = "login"),

    
    
       
        
    )

