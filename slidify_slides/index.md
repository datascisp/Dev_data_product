---
title       : Fitting mtcars dynamically.
subtitle    : Coursera Developing Data Products
framework   : html5slides   # {io2012, html5slides, shower, dzslides, ...}
highlighter : highlight.js  # {highlight.js, prettify, highlight}
hitheme     : tomorrow      # 
widgets     : []            # {mathjax, quiz, bootstrap}
mode        : selfcontained # {standalone, draft}

---

## Project Idea

* The project loads the popular **mtcars** data frame.
* It allow the user to fit dynamically any column in the data frame on any set of predictors.
* The left side panel is used to select the **outcome** and the **predictors**.
* The server then process dynamically the inputs and generate the output on the right panel.


--- .class #id 

## Server processing
* The server carryout several processing:
 1. It subsets the **mtcars** data frame based on the user selection.
 2. It draw a pairs plot holding both the **predictors** and the **outcome**.
 3. It fits a linear model based on that selection and dumps a summary of the fit.
 4. It prints out the subset of the dataframe for the user.

---

## Sample of the user plot

![plot of chunk unnamed-chunk-1](assets/fig/unnamed-chunk-1.png) 

---

## Sample of the server R code

```r
prepare_data_frame <- function(outcome,predictors) {
  df <- cbind(mtcars[,outcome],mtcars[,predictors])
  colnames(df) <- c(outcome,predictors)
  return(df)
}

require(shiny)
shinyServer(
  function(input, output) {
    output$y <- renderPrint({input$outcome})
    output$x <- renderPrint({input$predictors})
    output$df <- renderPrint({prepare_data_frame(input$outcome,input$predictors)})
    output$pair_plot <- renderPlot({
      df1 <- prepare_data_frame(input$outcome,input$predictors)
      pairs(df1)})
    output$my_model <- renderPrint({
      f0 <- paste(input$outcome,"~",paste(input$predictors,collapse="+"),sep="")
      f1 <- formula(f0)
      lm1 <- lm(f1,data=mtcars)
      summary(lm1)
    })})
```


---
## User Interface code

```r
shinyUI(
  pageWithSidebar(
    headerPanel("Fitting mtcars variables and predictors"),
    sidebarPanel(
      h2("Introduction"),
      p("This application fits any outcome in the mtcars data frame with any number of predictors within the mtcars. It visualizes the output and predictors relationship in scatter matrix and the linear model summary is displayed below the scatter matrix."),
      h2("Choosing Outcome and Predictors"),
      h3("Chossing Outcome"),
      selectInput("outcome", "Choose Outcome", colnames(mtcars), selected = "mpg", multiple = FALSE,selectize = TRUE),
      h3("Chossing predictors"),
      checkboxGroupInput("predictors","Choose Predictors",colnames(mtcars),selected = "wt"),
      includeMarkdown(path="./help.Rmd")),    
    mainPanel(
      h2("Scattar Plot and Model Results"),
      h3("Scatter Plot"),
      plotOutput('pair_plot'),
      h3("Model Results"),
      verbatimTextOutput("my_model"),
      h3("Data"),
      verbatimTextOutput("df"))))
```




