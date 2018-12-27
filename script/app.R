#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)

# Define UI for application that draws a histogram
ui <- fluidPage(
   
   # Application title
   titlePanel("HTBエナジー可視化ツール"),
   
   # Sidebar with a slider input for number of bins 
   sidebarLayout(
      sidebarPanel(
         fileInput("file",
                   "ファイル選択",
                   accept = c(
                     "text/csv",
                     "text/comma-separated-values,text/plain",
                     ".csv")),
         dateRangeInput("date",
                     "日付選択",
                   language = "ja"),
         radioButtons("graph",
                      "表示するグラフ",
                      choiceNames = c("使用タイミング折れ線",
                                      "一番使ってる時間は？"),
                      choiceValues = c("lines", "hist"))
      ),
      
      # Show a plot of the generated distribution
      mainPanel(
         plotOutput("distPlot")
      )
   )
)

# Define server logic required to draw a histogram
server <- function(input, output, session) {
  session$onSessionEnded(function(){
    stopApp()
    q("no")
  })
  observe({
    if(!is.null(input$file)){
      csvData = read.csv(file(input$file$datapath, encoding = "cp932"), skip = 2, row.names = 1)
      minDate <- min(as.Date(rownames(csvData), "%Y%m%d"))
      maxDate <- max(as.Date(rownames(csvData), "%Y%m%d"))
      updateDateRangeInput(session, "date", min = minDate, max = maxDate, start = minDate, end = maxDate)
    }
  })
  
  output$distPlot <- renderPlot({
    csvData <- NULL
    if(!is.null(input$file)){
      csvData = read.csv(file(input$file$datapath, encoding = "cp932"), skip = 2, row.names = 1)
      names(csvData) <- sapply(names(csvData), function(str){
        x <- strsplit(str, "[.]")
        x[[1]] <- sub("X","",x[[1]])
        paste(x[[1]][1], ":", x[[1]][2], "-", x[[1]][3], ":", x[[1]][4], sep = "")
      })
    }
    if(!is.null(csvData)){
      par(oma = c(1,0,0,0))
      minDate <- min(as.Date(rownames(csvData), "%Y%m%d"))
      maxDate <- max(as.Date(rownames(csvData), "%Y%m%d"))
      if(!is.na(input$date[1]) && !is.na(input$date[2]) && input$date >= minDate && input$date <= maxDate){
        dateRange <-strftime(seq(min(input$date), max(input$date), by = "day"), format = "%Y%m%d")
        plotData <- csvData[dateRange,]
          if(input$graph == "lines"){
          timeRange <- 1:ncol(plotData)
          plot(0, 0, type = "n", ylim = range(plotData), xlim = range(timeRange), ylab = "kWh", xlab = "", xaxt = "n")
          axis(side = 1, at = timeRange, labels =  names(plotData), las = 2)
          lineCol <- 2
          lineLty <- 1
          lineNames <- NULL
          lineCols <- NULL
          lineLtys <- NULL
          for(i in 1:nrow(plotData)){
            lines(timeRange, plotData[i,], col = lineCol, lty = lineLty)
            lineNames <- append(lineNames,rownames(plotData[i,])[1])
            lineCols <- append(lineCols,lineCol)
            lineLtys <- append(lineLtys,lineLty)
            lineCol = lineCol + 1
            if(lineCol > 8){
              lineCol = 2
              lineLty = lineLty + 1
            }
          }
          legend("topleft", legend = lineNames, col = lineCols, lty = lineLtys, ncol = 3)
        }else if(input$graph == "hist"){
          maxPoint <- apply(plotData, 1, which.max)
          hist(maxPoint, breaks = 24, xaxt = "n" ,xlab = "", ylab = "dates", main = NULL, col = "blue")
          axis(side = 1, at = 1:ncol(plotData), labels = colnames(plotData), las = 2)
        }
      }
    }
  })
}

# Run the application 
shinyApp(ui = ui, server = server)

