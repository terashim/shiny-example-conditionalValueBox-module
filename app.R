library(shiny)
library(shinydashboard)

# Shiny modulesを使って conditionalValueBox を定義 ----------
conditionalValueBoxUI <- function(id) {
  ns <- NS(id)
  
  tagList(
    valueBoxOutput(ns("valueBox"))
  )
}

conditionalValueBox <- function(input, output, session, value) {
  output$valueBox <- renderValueBox({
    valueBox(
      subtitle = ifelse(value() > 0, "いいね", "わるいね"),
      value = value(),
      color = ifelse(value() > 0, "green", "red"),
      icon = icon(ifelse(value() > 0, "thumbs-up", "thumbs-down"))
    )
  })
}

# UI側 ----------
ui <- dashboardPage(
  dashboardHeader(title = "Shiny modues 小品"),
  dashboardSidebar(
    sliderInput(inputId = "value1", label = "値1", value = -2, min = -5, max = 5),
    sliderInput(inputId = "value2", label = "値2", value = 1, min = -5, max = 5)
  ),
  dashboardBody(
    h2("値によって色が変わる valueBox"),
    p("値が1以上なら緑色、0以下なら赤色になる"),
    
    fluidRow(column(
      12,
      h3("値1について"),
      conditionalValueBoxUI("vb1")
    )),
    
    fluidRow(column(
      12,
      h3("値2について"),
      conditionalValueBoxUI("vb2")
    ))
  )
)

# サーバー側 ----------
server <- function(input, output) {
  callModule(conditionalValueBox, "vb1", reactive(input$value1))
  callModule(conditionalValueBox, "vb2", reactive(input$value2))
}

# アプリの起動 ----------
shinyApp(ui = ui, server = server)
