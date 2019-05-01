# The server-part for the WordPrediction app

library(shiny)
library(data.table)
library(stringr)
source("predictor.R")
refDT <- readRDS("Data/refDT.rds")
top10 <- readRDS("Data/top10.rds")
setkey(refDT, source)

# Define server logic required to predict next word based on UI-input
shinyServer(function(input, output) {
  output$predictWord1 <- renderText({
          predictWord(refDT, input$textInput, top10)[1]
  })
  output$predictWord2 <- renderText({
      predictWord(refDT, input$textInput, top10)[2]
  })
  output$predictWord3 <- renderText({
      predictWord(refDT, input$textInput, top10)[3]
  })
})
