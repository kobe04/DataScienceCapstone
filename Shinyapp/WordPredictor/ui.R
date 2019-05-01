# The UI for the wordprediction app

library(shiny)

# Define UI for application that predicts the next word, based on the user-input
shinyUI(fluidPage(
  
  # Application title
  titlePanel("Predicting next word"),
  
  # Sidebar with a textual input for the user 
  sidebarLayout(
    sidebarPanel(
      textInput("textInput", label = "Please insert one or multiple words: ", value = ""),
      helpText("You can enter every character you want, but the dataset does not contain numbers.
               The algorithm is designed to predict for the english language.
               THE FIRST TIME THE APP GIVES A PREDICTION, IT MIGHT TAKE ABOUT 30 SECONDS."),
      submitButton("Done")
    ),
    
    # Show the three predicted options on the first tab, and the manual on the second tab
    mainPanel(
      tabsetPanel(
        tabPanel(h2("Predictions"),
                 br(),
                 h4("First choice: "), textOutput("predictWord1"),
                 br(),
                 h4("Second choice: "), textOutput("predictWord2"),
                 br(),
                 h4("Third choice: "), textOutput("predictWord3")),
        tabPanel(h2("Manual"), includeHTML("Manual.html")),
        br(),
        br(),
        br(),
        br(),
        br(),
        br(),
        hr(),
        img(src = "jhuLogo.png", height = 70, width = 200),
        a("Johns Hopkins University", href = "https://www.jhu.edu/"),
        br(),
        img(src = "courseraLogo.png", height = 70, width = 200),
        a("Coursera", href = "https://www.coursera.org/"),
        br(),
        img(src = "swiftkeyLogo.png", height = 80, width = 80),
        a("Swiftkey", href = "https://www.microsoft.com/en-us/swiftkey?rtc=1&activetab=pivot_1%3aprimaryr2"),
        br(),
        br(),
        br(),
        helpText("K. van Splunter, April 2019")
      )
    )
  )
))
