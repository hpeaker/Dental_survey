choiceDataTableUI <- function(id) {
  ns <- NS(id)
  
  tagList(
    DT::dataTableOutput(ns("dt")),
    radioButtons(ns("r"), "Choose One",
                 c("Alternative 1", "Alternative 2"),
                 selected = 0)
  )
}

choiceDataTable <- function(input, output, session, data) {
  ns <- session$ns
  
  output$dt <- DT::renderDataTable({
    datatable(
      data,
      rownames = TRUE,
      class = "compact display",
      selection = list(mode = "single", target = "column"),
      options = list(dom = "t")
    )
  })
  
  
  proxy = dataTableProxy("dt")
  
  observeEvent(input$r, {
    a <- input$r
    if(a == "Alternative 1") {
      proxy %>% selectColumns(1)
    }
    if(a == "Alternative 2") {
      proxy %>% selectColumns(2)
    }
    
    
  })
  
  
  observeEvent(input$dt_columns_selected, {
    r <- input$dt_columns_selected
    s <- if(r == 1) {
      "Alternative 1"
    } else if (r == 2) {
      "Alternative 2"
    } 
    
    
    updateRadioButtons(session, "r", 
                       selected = s)
  })
  
  selected <- reactive({
    data[, input$dt_columns_selected + 1]
  })
  
  return(reactive(input$dt_columns_selected + 1))
}

