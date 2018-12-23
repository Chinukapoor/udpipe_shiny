library(igraph)
library(ggraph)
library(ggplot2)
library(shiny)
library(udpipe)
library(shinythemes)
library(dplyr)
require(stringr)
library(wordcloud)
server <- function(input, output) {
  
  dataset <- reactive({
    inFile <- input$file1
    if (is.null(inFile))
      return(NULL)
    raw_data <- readLines(inFile$datapath)
    str(raw_data)
    return(raw_data)
  })
  
  output$lang <- renderText({ 
    paste("Udpipe model selected for language:", input$select)
  })
  
  english_model = reactive({
    x <- udpipe_download_model(language = input$select)
    ud_english <- udpipe_load_model(x$file_model)
    return(ud_english)
  })
  
  
  annotated_obj = reactive({
    x <- udpipe_annotate(english_model(),dataset())
    x <- as.data.frame(x)
    return(x)
  })
  
  output$wcplot2 = renderPlot({
    width = "auto"
    height = "auto"
    all_verbs = annotated_obj() %>% subset(., upos %in% "VERB") 
    top_verbs = txt_freq(all_verbs$lemma)
    wordcloud(top_verbs$key,top_verbs$freq, min.freq = 3,colors = 1:10)
  })
  
  output$wcplot1 = renderPlot({
    all_verbs = annotated_obj() %>% subset(., upos %in% "NOUN") 
    top_verbs = txt_freq(all_verbs$lemma)
    wordcloud(top_verbs$key,top_verbs$freq, min.freq = 3,colors = 1:5)
  }
  )
  output$wcplot3 = renderPlot({
    all_verbs = annotated_obj() %>% subset(., upos %in% "ADJ") 
    top_verbs = txt_freq(all_verbs$lemma)
    wordcloud(top_verbs$key,top_verbs$freq, min.freq = 3,colors = 1:10)
  }
  )
  output$wcplot4 = renderPlot({
    all_verbs = annotated_obj() %>% subset(., upos %in% "ADV") 
    top_verbs = txt_freq(all_verbs$lemma)
    wordcloud(top_verbs$key,top_verbs$freq, min.freq = 3,colors = 1:10)
  }
  )
  output$wcplot5 = renderPlot({
    all_verbs = annotated_obj() %>% subset(., upos %in% "PROPN") 
    top_verbs = txt_freq(all_verbs$lemma)
    wordcloud(top_verbs$key,top_verbs$freq, min.freq = 3,colors = 1:5)
  }
  )
  output$coocplot = renderPlot({
    nokia_cooc <- cooccurrence(   	
      x = subset(annotated_obj(), upos %in% input$upos), 
      term = "lemma", 
      group = c("doc_id", "paragraph_id", "sentence_id"))
    
    wordnetwork <- head(nokia_cooc, 50)
    wordnetwork <- igraph::graph_from_data_frame(wordnetwork) # needs edgelist in first 2 colms.
    
    ggraph(wordnetwork, layout = "fr") +  
      
      geom_edge_link(aes(width = cooc, edge_alpha = cooc), edge_colour = "orange") +  
      geom_node_text(aes(label = name), col = "darkgreen", size = 6) +
      
      theme_graph(base_family = "Arial Narrow") +  
      theme(legend.position = "none") +
      
      labs(title = "Cooccurrences within 3 words distance", subtitle = "Select the check boxes in the left pane")
  })
  
  
  
  
}



