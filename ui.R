ui <- fluidPage(
  theme = shinytheme("united"),
  titlePanel("Exploring Text-An using UDPipe"),
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
      fileInput("file1", "Choose Text File",  #to take the file input from the user
                accept = c(
                  "text/csv",
                  "text/comma-separated-values,text/plain",
                  ".csv")
                
      ),
      
      
      tags$hr(),
      
      checkboxGroupInput(inputId = 'upos',
                         label = p('Choose pos for co-occurences filtering:'),
                         choices =list("Adjective"= "ADJ",
                                       "Noun" = "NOUN",
                                       "Proper noun" = "PROPN",
                                       "Adverb"="ADV",
                                       "Verb"= "VERB"),
                         selected = c("ADJ","NOUN","PROPN")
                         
      ),
      tags$hr(),
      
      selectInput("select", 
                  label = p("Select Language"), #available options for UDPipe models
                  choices = c("english","spanish", "french","german","hindi","korean","persian",
                              "chinese","dutch","irish","italian","latin","greek","japanese","portuguese"), 
                  selected = NULL
      ),
      useShinyalert(), #for shiny alerts
      useShinyjs() 
      
      
    ),
    mainPanel(
      
      tabsetPanel(type = "tabs",   
                  
                  tabPanel("Overview", 
                           h4("App Details"),
                           p("For the best user experience, open in browser (recommended)", align="justify"),
                           br(),
                           p("This application performs basic NLP functions for a given text corpus:", align="justify"),
                           p("1. Word Clouds for part of speech tags"),
                           p("2. Co-occurence Graph for pos tags"),
                           p("3. Basic sentiment analysis for polarity (valid for english text only"),
                           br(),
                           withSpinner(textOutput("lang"), type = getOption("spinner.type", default = 6),
                                       size = getOption("spinner.size", default = 1)),
                           br(),
                           
                           p("By default, the udpipe for English is downloaded when you launch the App."
                             , align="justify"),
                           
                           p("You are free to choose a udpipe model from the drop down on the left side panel.\
                             The App downloads it for you and sets it for your workspace.",style = "color:red"),
                           
                           h4("How to use the App",style = "color:black"),
                           
                           p("Upload your text corpus through the file upload option on the top left.", align="justify"),
                           
                           p("Click on Word Cloud, Co-occurences graph and Simple Sentiment Analysis to dive into your text corpus.",
                             style="color:black"),
                           
                           br(),
                           tableOutput("contents")
                           ),
                  tabPanel("Word Clouds",
                           h4("Verbs"),
                           withSpinner(plotOutput('word_cld_plot2', width="100%"), type = getOption("spinner.type", default = 6),
                                       size = getOption("spinner.size", default = 1)),
                           h4("Nouns"),
                           withSpinner(plotOutput("word_cld_plot1", width = "100%"), type = getOption("spinner.type", default = 6),
                                       size = getOption("spinner.size", default = 1)),
                           h4("Adjective"),
                           withSpinner(plotOutput("word_cld_plot3", width = "100%"), type = getOption("spinner.type", default = 6),
                                       size = getOption("spinner.size", default = 1)),
                           h4("Adverbs"),
                           withSpinner(plotOutput("word_cld_plot4"), type = getOption("spinner.type", default = 6),
                                       size = getOption("spinner.size", default = 1)),
                           h4("Proper Nouns"),
                           withSpinner(plotOutput("word_cld_plot5"), type = getOption("spinner.type", default = 6),
                                       size = getOption("spinner.size", default = 1))
                           
                           
                  ),
                  tabPanel("Co-occurences Graph",
                           h4("Co-occurrences"),
                           withSpinner(plotOutput('coocrencesplot'), type = getOption("spinner.type", default = 6),
                                       size = getOption("spinner.size", default = 1))
                           
                  ),
                  
                  tabPanel("Simple Sentiment Analysis",
                           h4("Polarity of the text"),
                           p("Please upload English text to see the sentiment graph.", style="color:brown"),
                           withSpinner(plotOutput("senti_plot"), type = getOption("spinner.type", default = 6),
                                       size = getOption("spinner.size", default = 1))
                  )
                  
      ))))
