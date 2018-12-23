library(igraph)
library(ggraph)
library(ggplot2)
library(shiny)
library(udpipe)
library(shinythemes)
library(dplyr)
require(stringr)
library(wordcloud)

ui <- fluidPage(
  theme = shinytheme("united"),
  titlePanel("NLP Basics in R"),
  tags$style("
             .checkbox { /* checkbox is a div class*/
             line-height: 5px;
             margin-bottom: 10px; /*set the margin, so boxes don't overlap*/
             }
             input[type='checkbox']{ /* style for checkboxes */
             width: 5px; /*Desired width*/
             height: 5px; /*Desired height*/
             line-height: 10px; 
             }
             span { 
             margin-left: 15px;  /*set the margin, so boxes don't overlap labels*/
             line-height: 10px; 
             }
             
             "),
  sidebarLayout(
    sidebarPanel(
      fileInput("file1", "Choose CSV File",
                accept = c(
                  "text/csv",
                  "text/comma-separated-values,text/plain",
                  ".csv")
                
      ),
      
      tags$hr(),
      
      checkboxGroupInput(inputId = 'upos',
                         label = p('Parts of Speech for co-occurrances filtering'),
                         choices =list("adjective"= "ADJ",
                                       "Noun" = "NOUN",
                                       "proper noun" = "PROPN",
                                       "adverb"="ADV","verb"= "VERB"),
                         selected = c("ADJ","NOUN","PROPN")
      
    ),
      tags$hr(),
      selectInput("select", 
                  label = p("Select Language"), 
                  choices = c("english","spanish", "french","german","hindi"), 
                  selected = NULL)
      
      
    ),
    mainPanel(
      
      tabsetPanel(type = "tabs",   
                  
                  tabPanel("Overview",   
                           h4("App Details"),
                           
                           p("This application performs basic NLP functions for a given \
                             text corpus.", align="justify"),
                           br(),
                           br(),
                           p("By Default, the udpipe for English is download. You need NOT upload a \
                             udpipe."),
                           br(),
                           p("Instead choose a udpipe model from the drop down.\
                             It will be downloaded to your workspace. "),
                           br(),
                           textOutput("lang"),
                           tableOutput("contents")
                           ),
                  tabPanel("Word Clouds",
                           h4("Verbs"),
                           plotOutput('wcplot2', width="100%"),
                           h4("Nouns"),
                           plotOutput("wcplot1", width = "100%"),
                           h4("Adjective"),
                           plotOutput("wcplot3", width = "100%"),
                           h4("Adverbs"),
                           plotOutput("wcplot4"),
                           h4("Proper Nouns"),
                           plotOutput("wcplot5")
                  ),
                  tabPanel("Co-occurences Graph",
                           h4("Co-occurrences"),
                           plotOutput('coocplot')
                          ))
                  )))

