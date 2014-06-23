#ui.R
require(shiny)
require(markdown)
require(knitr)

data(mtcars)

shinyUI(
  pageWithSidebar(
    headerPanel("Fitting mtcars variables and predictors"),
    sidebarPanel(
      h2("Introduction"),
      p("This application fits any outcome in the mtcars data frame with any number of 
        predictors within the mtcars. It visualizes the output and predictors relationship in scatter matrix 
        and the linear model summary is displayed below the scatter matrix."),
      h2("Choosing Outcome and Predictors"),
      h3("Chossing Outcome"),
      selectInput("outcome", "Choose Outcome", colnames(mtcars), selected = "mpg", multiple = FALSE,
                  selectize = TRUE),
      h3("Chossing predictors"),
      checkboxGroupInput("predictors","Choose Predictors",colnames(mtcars),selected = "wt"),
      includeMarkdown(path="./help.Rmd")
      
    ),    
    mainPanel(
      h2("Scattar Plot and Model Results"),
      h3("Scatter Plot"),
      plotOutput('pair_plot'),
      h3("Model Results"),
      verbatimTextOutput("my_model"),
      h3("Data"),
      verbatimTextOutput("df")
      
    )
  )
  
)