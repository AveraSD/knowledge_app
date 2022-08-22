#' Knw Table Module UI
#'
#' The UI portion of the module for displaying the KNDB.sqlite database finalTb file
#'
#' @importFrom shiny NS tagList fluidRow column actionButton tags
#' @importFrom DT DTOutput
#' @importFrom shinycssloaders withSpinner
#'
#' @param id The id for this module
#'
#' @return a \code{shiny::\link[shiny]{tagList}} containing UI elements
#'
knw_table_module_ui <- function(id) {
  ns <- NS(id)
  
  tagList(
    fluidRow(
      column(
        width = 12,
        h2(strong("Avera Cancer Genomic Biomarkers Database")),
        br(),
        helpText("Notes:"),
        br(),
        br()
      )
    ),
    fluidRow(
      column(
        width = 2,
        actionButton(
          ns("add_car"),
          "Add New Entry Here",
          class = "btn-success",
          style = "color: #fff;",
          icon = icon('plus'),
          width = '100%'
        ),
        tags$br(),
        tags$br(),
        tags$br(),
        tags$br()
      )
    ),
    fluidRow(
      column(
        width = 12,
        title = "The Avera Genomics Cancer Database",
        #DTOutput(ns('car_table'))
        tags$br(),
        DTOutput(ns('db_table')) %>%
          withSpinner(),
        tags$br(),
        tags$br()
      )
    ),
    tags$script(src = "knw_table_module.js"),
    tags$script(paste0("knw_table_module_js('", ns(''), "')"))
  )
}

#' Cars Table Module Server
#'
#' The Server portion of the module for displaying the mtcars datatable
#'
#' @importFrom shiny reactive reactiveVal observeEvent req callModule eventReactive
#' @importFrom DT renderDT datatable replaceData dataTableProxy
#' @importFrom dplyr tbl collect mutate arrange select filter pull
#' @importFrom purrr map_chr
#' @importFrom tibble tibble
#'
#' @param None
#'
#' @return None

cars_table_module <- function(input, output, session) {

  # trigegr to reload data from the "finalTb" table
  
  session$userData$knwtb_trigger <- reactiveVal(0)

  # Read in "finalTb" table from the database
 
  knwdf <- reactive({
    session$userData$knwtb_trigger()

    out <- NULL
    tryCatch({
      #out <- tbl(conn, 'finalTb')
      out <- dbGetQuery(conn, "SELECT * FROM finalTb ")
        
    }, error = function(err) {


      msg <- "Database Connection Error"
      # print `msg` so that we can find it in the logs
      print(msg)
      # print the actual error to log it
      print(error)
      # show error `msg` to user.  User can then tell us about error and we can
      # quickly identify where it cam from based on the value in `msg`
      showToast("error", msg)
    })

    out
  })

  
  inittable_prep <- reactiveVal(NULL)
  
  # get the counter for the new entry row
  count_id <- eventReactive(knwdf(),{
    cntin = knwdf()
    counter = as.integer(nrow(cntin))
    counter
  })

  
  #observeEvent(cars(), {
   # out <- cars()
  observeEvent(knwdf(), {
    out <- knwdf()

    ids <- out$EntryID

    actions <- purrr::map_chr(ids, function(EntryID) {
      paste0(
        '<div class="btn-group" style="width: 75px;" role="group" aria-label="Basic example">
          <button class="btn btn-primary btn-sm edit_btn" data-toggle="tooltip" data-placement="top" title="Edit" id = ', EntryID, ' style="margin: 0"><i class="fa fa-pencil-square-o"></i></button>
          <button class="btn btn-danger btn-sm delete_btn" data-toggle="tooltip" data-placement="top" title="Delete" id = ', EntryID, ' style="margin: 0"><i class="fa fa-trash-o"></i></button>
        </div>'
      )
    })

    # # Remove the `uid` column. We don't want to show this column to the user
    # out <- out %>%
    #   select(-uid)

    # Set the Action Buttons row to the first column of the `mtcars` table
    out <- cbind(
      tibble(" " = actions),
      out
    )
    #if (is.null(car_table_prep())) {
    if (is.null(inittable_prep())) {
      # loading data into the table for the first time, so we render the entire table
      # rather than using a DT proxy
      #car_table_prep(out)
      inittable_prep(out)

    } else {

      # table has already rendered, so use DT proxy to update the data in the
      # table without rerendering the entire table
      replaceData(car_table_proxy, out, resetPaging = FALSE, rownames = FALSE)

    }
  })
  
 
  # the server side 
  output$db_table <- renderDT({
    
    #req(car_table_prep())
    #out <- car_table_prep()
    
    req(inittable_prep())
    out <- inittable_prep()

    datatable(
      out,
      rownames = FALSE,
      colnames = c(names_map$display_names),
      selection = "none",
      filter = list(position = 'top', clear = FALSE),
      class = "compact stripe row-border nowrap",
      # Escape the HTML in all except 1st column (which has the buttons)
      escape = -1,
      extensions = c("Buttons"),
      options = list(
        order = list(1, 'desc'),
        pageLength = 35,
        scrollX = TRUE,
        dom = 'Bftip',
        buttons = list(
          list(
            extend = "excel",
            text = "Download",
            title = paste0("knowledgebase-", Sys.Date()),
            exportOptions = list(
              columns = 1:(length(out) - 1)
            )
          )
        ),
        
        drawCallback = JS("function(settings) {
          // removes any lingering tooltips
          $('.tooltip').remove()
        }")
      )
    ) 
      

  })
  
  
  #car_table_proxy <- DT::dataTableProxy('car_table')
  car_table_proxy <- DT::dataTableProxy('db_table')

  callModule(
    car_edit_module,
    "add_car",
    modal_title = "Add Entry",
    car_to_edit = function() NULL,
    modal_trigger = reactive({input$add_car}),
    counter_id = count_id
  )
#   
  car_to_edit <- eventReactive(input$car_id_to_edit, {
    #cars() %>%
    knwdf() %>%
      filter(EntryID == input$car_id_to_edit)
  })

  callModule(
    car_edit_module,
    "edit_car",
    modal_title = "Edit Car",
    car_to_edit = car_to_edit,
    modal_trigger = reactive({input$car_id_to_edit}),
    counter_id = count_id
  )
#   
  
  #car_to_delete <- eventReactive(input$car_id_to_delete, {
  to_delete <- eventReactive(input$car_id_to_delete, {
      #out <- cars() %>%
    out <- knwdf() %>%
      filter(EntryID == input$car_id_to_delete) %>%
      as.list()
  })
 
  callModule(
    delete_module,
    "delete_car",
    modal_title = "Delete",
    to_delete = to_delete,
    modal_trigger = reactive({input$car_id_to_delete})
  )

 }
