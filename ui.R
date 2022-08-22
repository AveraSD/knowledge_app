#
# This is the user-interface definition of a Shiny web application. You can
# 
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)

# Define UI for application that draws a histogram
shinyUI(dashboardPage(skin = "green",
                      title="Avera Knowledge Form",
                      dashboardHeader(
                        title = span("Knowledge Base",style ='font-size: 20px; font-weight: bold;'),
                        tags$li(
                          class = "dropdown",
                          style = "padding: 8px;",
                          shinyauthr::logoutUI("logout")
                        )
                        # tags$li(
                        #   class = "dropdown",
                        #   tags$a(
                        #     icon("github"),
                        #     href = "https://github.com/paulc91/shinyauthr",
                        #     title = "See the code on github"
                        #   )
                        # )
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
                      dashboardBody(
                        shinyauthr::loginUI(
                          "login", 
                          #cookie_expiry = cookie_expiry, 
                          additional_ui = tagList(
                            tags$p("Forgot password! Message Shivani!", class = "text-center"),
                          )
                        ),
                        uiOutput("testUI")
                      ))
)
