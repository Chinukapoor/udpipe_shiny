#Ayush Kapoor - 11810053 #Kumar Varun - 11810114 #Rohit Motwani- 11810079
try(require(shiny) || install.packages("shiny"))
if (!require(dplyr)){install.packages("dplyr")}
if (!require(wordcloud)){install.packages("wordcloud")}
if (!require(udpipe)){install.packages("udpipe")}
if (!require(igraph)){install.packages("igraph")}
if (!require(ggraph)){install.packages("ggraph")}
if (!require(ggplot2)){install.packages("ggplot2")}
if (!require(stringr)){install.packages("stringr")}
if (!require(shinythemes)){install.packages("shinythemes")}
if (!require(shinyalert)){install.packages("shinyalert")}
if (!require(shinycssloaders)){install.packages("shinycssloaders")}
if (!require(shinyjs)){install.packages("shinyjs")}
if (!require()){install.packages("tidytext")}


library(igraph)
library(ggraph)
library(ggplot2)
library(shiny)
library(udpipe)
library(shinythemes)
library(dplyr)
require(stringr)
library(wordcloud)
library(shinyalert)
library(shinycssloaders)
library(shinyjs)
library(tidytext)
