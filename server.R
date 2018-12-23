server <- function(input, output) {
  options(shiny.maxRequestSize = 50*1024^2)
  dataset <- reactive({
    inFile <- input$file1
    if (is.null(inFile))
      return(NULL)
    raw_data <- readLines(inFile$datapath)
    str(raw_data)
    return(raw_data)
  })
  
  output$lang <- renderText({ 
    paste("You have selected UDPipe model for: ", input$select)
  })
  
  udpipe_model = reactive({
    x <- udpipe_download_model(language = input$select)
    ud_english <- udpipe_load_model(x$file_model)
    shinyalert(title = paste("Udpipe Model uploaded for", input$select), type = "success", timer=5000)
    return(ud_english)
  })
  observeEvent(input$select, {
    udpipe_model() 
    
  })
  
  
  output$senti_plot = renderPlot({
    tokens <- data_frame(text = dataset()) %>% unnest_tokens(word, text)
    senti_data<- tokens %>%
      inner_join(get_sentiments("bing")) %>% # pull out only sentiment words
      count(sentiment) %>% as.data.frame()
    
    ggplot(senti_data, aes(sentiment, n)) + geom_bar(stat = "identity",fill="steelblue" ) + theme_minimal()
  })
  
  annotated_obj = reactive({
    x <- udpipe_annotate(udpipe_model(),dataset())
    x <- as.data.frame(x)
    return(x)
  })
  
  output$word_cld_plot2 = renderPlot({
    width = "auto"
    height = "auto"
    all_verbs = annotated_obj() %>% subset(., upos %in% "VERB") 
    top_verbs = txt_freq(all_verbs$lemma)
    wordcloud(top_verbs$key,top_verbs$freq, min.freq = 3,colors = 1:10)
  })
  
  output$word_cld_plot1 = renderPlot({
    all_verbs = annotated_obj() %>% subset(., upos %in% "NOUN") 
    top_verbs = txt_freq(all_verbs$lemma)
    wordcloud(top_verbs$key,top_verbs$freq, min.freq = 3,colors = 1:5)
  }
  )
  output$word_cld_plot3 = renderPlot({
    all_verbs = annotated_obj() %>% subset(., upos %in% "ADJ") 
    top_verbs = txt_freq(all_verbs$lemma)
    wordcloud(top_verbs$key,top_verbs$freq, min.freq = 3,colors = 1:10)
  }
  )
  output$word_cld_plot4 = renderPlot({
    all_verbs = annotated_obj() %>% subset(., upos %in% "ADV") 
    top_verbs = txt_freq(all_verbs$lemma)
    wordcloud(top_verbs$key,top_verbs$freq, min.freq = 3,colors = 1:10)
  }
  )
  output$word_cld_plot5 = renderPlot({
    all_verbs = annotated_obj() %>% subset(., upos %in% "PROPN") 
    top_verbs = txt_freq(all_verbs$lemma)
    wordcloud(top_verbs$key,top_verbs$freq, min.freq = 3,colors = 1:5)
  }
  )
  output$coocrencesplot = renderPlot({
    cooc1 <- cooccurrence(   	
      x = subset(annotated_obj(), upos %in% input$upos), 
      term = "lemma", 
      group = c("doc_id", "paragraph_id", "sentence_id"))
    
    wordnetwork <- head(cooc1, 50)
    wordnetwork <- igraph::graph_from_data_frame(wordnetwork) # needs edgelist in first 2 colms.
    
    ggraph(wordnetwork, layout = "fr") +  
      
      geom_edge_link(aes(width = cooc, edge_alpha = cooc), edge_colour = "black") +  
      geom_node_text(aes(label = name), col = "brown", size = 6) +
      
      theme_graph(base_family = "Arial Narrow") +  
      theme(legend.position = "none") +
      
      labs(title = "Co-occurrences within 3 words distance", subtitle = "Select pos tags from the left pane")
  })
}
