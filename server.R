#server.R

#setwd("C:/Coursera/Developing Data Products/Project")

prepare_data_frame <- function(outcome,predictors) {
  df <- cbind(mtcars[,outcome],mtcars[,predictors])
  df <- as.data.frame(df)
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
      pairs(df1)
        })
    output$my_model <- renderPrint({
      f0 <- paste(input$outcome,"~",paste(input$predictors,collapse="+"),sep="")
      f1 <- formula(f0)
      lm1 <- lm(f1,data=mtcars)
      summary(lm1)
    })
    
  }
)