
#' Add & Edit Module
#'
#' Module to add & edit entries in the KNDB.sqlite database finalTb file
#'
#' @importFrom shiny observeEvent showModal modalDialog removeModal fluidRow column textInput numericInput selectInput modalButton actionButton reactive eventReactive
#' @importFrom shinyFeedback showFeedbackDanger hideFeedback showToast
#' @importFrom shinyjs enable disable
#' @importFrom lubridate with_tz
#' @importFrom EntryId updated from reactive  counter_id
#' @importFrom DBI dbExecute and dbAppendTable
#'
#' @param modal_title string - the title for the modal
#' @param car_to_edit reactive returning a 1 row data frame of the car to edit
#' from the "finalTb" table
#' @param modal_trigger reactive trigger to open the modal Add or Edit buttons
#'
#' @return None
#'
car_edit_module <- function(input, output, session, modal_title, car_to_edit, modal_trigger, counter_id ) {
  ns <- session$ns
  
  observeEvent(modal_trigger(), {
    hold <- car_to_edit()
    
    showModal(
      modalDialog(
        fluidRow(
          column(
            width = 6,
            shinyjs::useShinyjs(),
            shinyjs::disabled(textInput(ns("id"), "ID#", ifelse(is.null(hold), 0, hold$EntryID)
            )),
            pickerInput(
              inputId = ns("genIn"),
              label = "Genes",
              choices = c(allgenes),
              multiple = T,
              selected = ifelse(is.null(hold), "", hold$Gene),
              #options = list(create = TRUE)
              options = list(`actions-box` = TRUE,`live-search` = TRUE,size=10)
            ),
            pickerInput(
              inputId = ns("altIn"),
              label = "Alteration",
              choices = c(varAll),
              multiple = T,
              selected = ifelse(is.null(hold), "", hold$Alteration),
              options = list(`actions-box` = TRUE,`live-search` = TRUE,size=10)
              # choicesOpt = list(
              #   style = rep_len("font-size: 100%",nrow(alltumor_type))
              #options = list(create = TRUE)
            ),
            pickerInput(
              inputId = ns("altType"),
              label = "Alteration Type",
              choices = c(funAlter),
              multiple = T,
              selected = ifelse(is.null(hold), "", hold$AlterationType)
              #options = list(create = TRUE)
              #options = list(`actions-box` = TRUE,
              #`live-search` = TRUE)
            ),
            awesomeRadio(
              inputId = ns("altAss"),
              label = "Association",
              choices = c(assolist),
              selected = ifelse(is.null(hold), "", hold$Association),
              status = "success",
              inline = T,
              checkbox = T
            ),
            pickerInput(
              inputId = ns("tum"),
              label = "TUMOR",
              choices = c(alltumor_type$Tumor),
              multiple = T,
              selected = ifelse(is.null(hold), "", hold$TumorType),
              options = list(`actions-box` = TRUE,`live-search` = TRUE,size=10),
              choicesOpt = list(
                style = rep_len("font-size: 100%",nrow(alltumor_type))
              ) 
              
            ),
            awesomeRadio(
              inputId = ns("tumGrp"),
              label = "Tumor Group",
              choices = c(tgrp),
              selected = ifelse(is.null(hold), "", hold$TumorGroup),
              status = "success",
              inline = T,
              checkbox = T
            ),
            textInput(ns("tumAbb"), "Tumor Abber",
                      ifelse(is.null(hold), "Don't Type", hold$TumorAcroym)
            ),
            
            awesomeRadio(
              inputId = ns("tarG"),
              label = "Targets",
              choices = c(targ),
              selected = ifelse(is.null(hold), "", hold$Target),
              status = "success",
              inline = T,
              checkbox = T
            ),
            textInput(ns("refe"), "References Information", 
                      ifelse(is.null(hold), "", hold$Reference1)
            )
          ),
          column(
            width = 6,
            #
            pickerInput(
              inputId = ns("druG"),
              label = "DRUG",
              choices = c(drg_name),
              multiple = T,
              selected = ifelse(is.null(hold), "", hold$DrugsName),
              options = list(`actions-box` = TRUE,`live-search` = TRUE,size=10),
              choicesOpt = list(
                style = rep_len("font-size: 100%",length(drg_name))
              ) 
              
            ),
            pickerInput(
              inputId = ns("drugfullname"),
              label = "Drug Full Name",
              choices = c(drugfulName),
              multiple = T,
              selected = ifelse(is.null(hold), "", hold$DrugFullName),
              options = list(`actions-box` = TRUE,`live-search` = TRUE,size=10),
              choicesOpt = list(
                style = rep_len("font-size: 100%",length(drugfulName))
              ) 
              
            ),
            pickerInput(
              inputId = ns("druFamy"),
              label = "Drug Family",
              choices = c(drugfam),
              multiple = T,
              selected = ifelse(is.null(hold), "", hold$DrugFamily),
              options = list(`actions-box` = TRUE,`live-search` = TRUE,size=10),
              choicesOpt = list(
                style = rep_len("font-size: 100%",length(drugfam))
              ) 
              
            ),
            pickerInput(
              inputId = ns("druStat"),
              label = "Drug Status",
              choices = c(drugstatus),
              multiple = T,
              selected = ifelse(is.null(hold), "", hold$DrugStatus),
              options = list(`actions-box` = TRUE,`live-search` = TRUE),
              choicesOpt = list(
                style = rep_len("font-size: 100%",length(drugstatus))
              ) 
            ),
            pickerInput(
              inputId = ns("druEvid"),
              label = "Drug Evidence Level",
              choices = c(eveidencelevl),
              multiple = T,
              selected = ifelse(is.null(hold), "", hold$DrugEvidence),
              options = list(`actions-box` = TRUE,`live-search` = TRUE),
              choicesOpt = list(
                style = rep_len("font-size: 100%",length(eveidencelevl))
              ) 
            ),
            textInput(ns("notes"), "Additional Notes",
                      ifelse(is.null(hold), "", hold$NotesInfo)
            ),
            
            pickerInput(
              inputId = ns("usrIn"),
              label = "Editor",
              choices = c(people),
              multiple = F,
              selected = ifelse(is.null(hold), "", hold$Curator),
              #options = list(create = TRUE)
              options = list(`actions-box` = TRUE,`live-search` = TRUE,size=5)
            )
          
          )
        ),
        title = modal_title,
        size = 'l',
        footer = list(
          modalButton('Cancel'),
          actionButton(
            ns('submit_add'),
            'Submit',
            class = "btn btn-primary",
            style = "color: white"
          )
        )
      )
    )
    # dateInput("date_input", "DATE", format = "mm/dd/yyyy")
    # Observe event for "Model" text input in Add/Edit Car Modal
    # `shinyFeedback`
  #   observeEvent(input$model, {
  #     if (input$model == "") {
  #       shinyFeedback::showFeedbackDanger(
  #         "model",
  #         text = "Must enter model of car!"
  #       )
  #       shinyjs::disable('submit')
  #     } else {
  #       shinyFeedback::hideFeedback("model")
  #       shinyjs::enable('submit')
  #     }
  #   })
  #   
  })
  
  
  
  # --------------------------------------------------------------------------------------------- #
  # --------------------------------------------------------------------------------------------- #
  
  
  CancerArco = eventReactive(input$tum, {
    #req(input$tumor_fullname)
    alltumor_type %>% 
      dplyr::filter(Tumor %in% input$tum) %>% 
      dplyr::select(abbe)
  })
  
  # update the input text on selection - cancer name
  observe({
    updateTextInput(session,"tumAbb",value = paste(CancerArco()))
  })
  
  
  
  # reactive for updating / adding the field information from the modal to a tibble 
  edit_car_dat <- reactive({
    hold <- car_to_edit()
   
    # tibble to update / store current data 
    out <- tibble(
      EntryID = input$id,
        Gene = ifelse(is.null(input$genIn),'NULL',input$genIn),
        Alteration = ifelse(is.null(input$altIn),'NULL',input$altIn),
        AlterationType = ifelse(is.null(input$altType),'NULL',input$altType),
        Association = ifelse(is.null(input$altAss),'NULL',input$altAss),
        TumorType = ifelse(is.null(input$tum),'NULL',input$tum),
        TumorAcroym = input$tumAbb,
        TumorGroup = ifelse(is.null(input$tumGrp),'NULL',input$tumGrp),
        Target = ifelse(is.null(input$tarG),'NULL',input$tarG),
        Reference1 = ifelse(input$refe == "",'NULL',input$refe),
        DrugsName = ifelse(is.null(input$druG),'NULL',input$druG),
        DrugFullName = ifelse(is.null(input$drugfullname),'NULL',input$drugfullname),
        DrugFamily = ifelse(is.null(input$druFamy),'NULL',input$druFamy),
        DrugStatus = ifelse(is.null(input$druStat),'NULL',input$druStat),
        DrugEvidence = ifelse(is.null(input$druEvid),'NULL',input$druEvid),
        NotesInfo = ifelse(input$notes == "",'NULL',input$notes),
        Curator = ifelse(is.null(input$usrIn),'NULL',input$usrIn)
    )
    
    time_now <- as.character(format(Sys.Date(),format = '%m/%d/%Y'))
    #userna = as.character(rectdf$usertb$user)
    if (is.null(hold)) {
      # adding a new 
      out$Date <- time_now
      
    } else {
      # Editing existing car
      
      out$Date <- time_now
      #out$data$Curator <- userna
    }
    out
    
  })
  
  validate_edit <- eventReactive(input$submit_add, {
    dat<- edit_car_dat()
    

    # Logic to validate inputs...
    
    
    #dat <- dat %>% mutate(across(everything(), ~replace(., is.na(.) , "NULL")))
    #

    dat
  })

# observeEvent(validate_edit(), {
#   dat  <- validate_edit()
#   print(colnames(dat))
#   #print(dat)
#   #print(input$genIn)
#  ## print(input$altAss)
#  # print(input$refe)
# 
#   })


observeEvent(validate_edit(), {
  dat  <- validate_edit()
  
  cnter = counter_id()
  removeModal()

  tryCatch({

    if (dat$EntryID == 0) {
      # creating a entry number
      dat$EntryID <- cnter +1
      
      dbAppendTable(conn, "finalTb", dat,row.names = NULL)
    } else {
      # editing an existing entry
      dbExecute(
        conn,
        "UPDATE finalTb SET Gene=$1, Alteration=$2, AlterationType=$3, Association=$4, TumorType=$5, TumorAcroym=$6, TumorGroup=$7,
        Target=$8, Reference1=$9, DrugsName=$10, DrugFullName=$11, DrugFamily=$12, DrugStatus=$13, DrugEvidence=$14,
        NotesInfo=$15, Curator=$16, Date=$17 WHERE EntryID=$18",
        params = c(
          unname(dat[,2:18]),
          list(dat$EntryID)
        )
      )
    }

    session$userData$knwtb_trigger(session$userData$knwtb_trigger() + 1)
    showToast("success", paste0(modal_title, " Successs"))
  }, error = function(error) {

    msg <- paste0(modal_title, " Error")


    # print `msg` so that we can find it in the logs
    print(msg)
    # print the actual error to log it
    print(error)
    # show error `msg` to user.  User can then tell us about error and we can
    # quickly identify where it cam from based on the value in `msg`
    showToast("error", msg)
  })

})

  
 
}