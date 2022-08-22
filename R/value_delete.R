#' Delete Module
#'
#' This module is for deleting a row's information from the KNDB.sqlite database finalTb file
#'
#' @importFrom shiny observeEvent req showModal h3 modalDialog removeModal actionButton modalButton
#' @importFrom DBI dbExecute
#' @importFrom shinyFeedback showToast
#'
#' @param modal_title string - the title for the modal
#' @param car_to_delete string - the entryID to be deleted
#' @param modal_trigger reactive trigger to open the modal (Delete button)
#'
#' @return None
#'


#car_delete_module <- function(input, output, session, modal_title, car_to_delete, modal_trigger) {
delete_module <- function(input, output, session, modal_title, to_delete, modal_trigger) {
  ns <- session$ns
  # Observes trigger for this module (here, the Delete Button)
  observeEvent(modal_trigger(), {
    
    showModal(
      modalDialog(
        div(
          style = "padding: 30px;",
          class = "text-center",
          h2(
            style = "line-height: 1.75;",
            
            
            paste0(
              'Are you sure you want to delete the "',
              to_delete()$Gene," ID: ",to_delete()$EntryID,
              
              '"?'
            )
          )
        ),
        title = modal_title,
        size = "m",
        footer = list(
          modalButton("Cancel"),
          actionButton(
            ns("submit_delete"),
            "Delete",
            class = "btn-danger",
            style="color: #fff;"
          )
        )
      )
    )
  })
  
  observeEvent(input$submit_delete, {
    #req(car_to_delete())
    req(to_delete())
    
    removeModal()
    
    tryCatch({
      
      #uid <- car_to_delete()$uid
      uid <- to_delete()$EntryID
      
      DBI::dbExecute(
        conn,
        "DELETE FROM finalTb WHERE EntryID=$1",
        params = c(uid)
      )
      
      session$userData$knwtb_trigger(session$userData$knwtb_trigger() + 1)
      showToast("success", "Successfully Deleted")
    }, error = function(error) {
      
      msg <- "Error Deleting"
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