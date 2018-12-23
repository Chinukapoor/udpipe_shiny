try(require(shiny) || install.packages("shiny"))
if (!require(dplyr)){install.packages("dplyr")}
if (!require(wordcloud)){install.packages("wordcloud")}
if (!require(udpipe)){install.packages("udpipe")}
if (!require(igraph)){install.packages("igraph")}
if (!require(ggraph)){install.packages("ggraph")}
if (!require(ggplot2)){install.packages("ggplot2")}
if (!require(stringr)){install.packages("stringr")}
if (!require(wordcloud)){install.packages("wordcloud")}
if (!require(shinythemes)){install.packages("shinythemes")}

library(shiny)
library(dplyr)
library(wordcloud)
library(udpipe)
library(igraph)
library(ggraph)
library(ggplot2)
library(stringr)
library(shinythemes)