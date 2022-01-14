library(tidyverse)
library(stringr)

#### Pick English, Catalan, Spanish or French and download list of 5 letter words ####

get.words <- function(language){
  if (language == "EN"){
    download.file("http://www.gwicks.net/textlists/usa.zip", words <- tempfile())
    words <- read_lines(words) %>% stri_trans_general("Latin-ASCII") %>% toupper() %>% unique()
    words <- words[str_length(words)==5]
  }
  if (language == "CAT"){
    words <- read_delim("https://raw.githubusercontent.com/Softcatala/catalan-dict-tools/master/resultats/lt/diccionari.txt", delim = " ", col_names = F, col_types = cols()) %>% filter(str_detect(X1,"^[:lower:]+$") & str_length(X1) == 5) 
    words <- stri_trans_general(words$X1, "Latin-ASCII") %>% toupper() %>% unique()
  }
  if (language == "ES"){
    download.file("http://www.gwicks.net/textlists/espanol.zip", words <- tempfile())
    words <- read_lines(words) %>% stri_trans_general("Latin-ASCII") %>% toupper() %>% unique()
    words <- words[str_length(words)==5]
  }
  if (language == "FR"){
    download.file("http://www.gwicks.net/textlists/francais.zip", words <- tempfile())
    words <- read_lines(words) %>% stri_trans_general("Latin-ASCII") %>% toupper() %>% unique()
    words <- words[str_length(words)==5]
  }
  return(words)
}

words <- get.words("EN") # EN, CAT, ES, FR

#### Play (more fun to check after playing, cheater) ####

# Create wordle function

wordle <- function(word, colors){
  
  if (str_length(word) != 5) {stop("Word must be 5 letters.")}
  if (str_length(colors) != 5) {stop("Must have 5 colors.")}
  if ((str_remove_all(str_remove_all(str_remove_all(colors,"y"),"g"),"x")) != "") {stop("Check colors: only y g & x are valid.")}
  
  ys <- str_which(unlist(str_split(colors,"")),"y")
  gs <- str_which(unlist(str_split(colors,"")),"g")
  xs <- str_which(unlist(str_split(colors,"")),"x")
  ygs <- c(c(str_sub(word,ys,ys)),c(str_sub(word,gs,gs)))
  x.ltrs <- c(str_sub(word,xs,xs))
  
  # Remove words incompatible with yellow squares
  if (length(ys) > 0) {
    for (i in ys){remain <- str_subset(remain,str_sub(word,i,i))}
    for (i in ys){remain <- remain[str_which(str_sub(remain,i,i),str_sub(word,i,i), negate = T)]}
  }
  
  # Remove words incompatible with green squares
  if (length(gs) > 0) {
    for (i in gs){remain <- remain[str_which(str_sub(remain,i,i),str_sub(word,i,i), negate = F)]}
  }
  
  # Remove words incompatible with gray squares
  if (length(xs) > 0) {for (i in xs){
    if (!str_sub(word,i,i) %in% ygs) {remain <- str_subset(remain,str_sub(word,i,i), negate = T)} else {remain[str_length(str_remove_all(remain,"s"))==(5-length(str_subset(ygs,str_sub(word,i,i))))]}
    }
  }
  
  # Remove words incompatible with any double yellow/green letters
  if (length(ygs[duplicated(ygs)])>0) {
    for (i in ygs[duplicated(ygs)]) {
      remain <- remain[str_length(str_remove_all(remain,i)) < 4]
    }
  }
  
  # Test each word for similarity with other remaining words
  for (i in remain){
    letters <- unique(unlist(str_split(i,"")))
    for (j in letters) {if (j == letters[1]) {test <- length(str_subset(remain,j))} else {test <- c(test, length(str_subset(remain,j)))}}
    
    if (i == remain[1]) {tests <- sum(test)} else {tests <- c(tests, sum(test))}
  }
  
  print(tibble(word = remain, similarity = tests) %>% mutate(similarity = as.numeric(scale(similarity))) %>% arrange(desc(similarity)))
  
  return(remain)
}

# Run this line to start new game.

remain <- words  

# Run this to find remaining words after each guess. 
# Colors are "y" for yellow, "g" for green, "x" for grey.
# "Similarity" variable ranks possible guesses by how many letters (in any position) they have in common with other remaining words (z-score).

remain <- wordle("RATES","ygxxx")  


#### Find best first words (takes a little while, be patient) ####

# Find how many letters each word matches with other words, in any position (yellows)

for (i in words){
  
  letters <- unique(unlist(str_split(i,"")))
  
  for (j in letters) {
    if (j == letters[1]) {yellow <- length(str_subset(words,j))} else {yellow <- c(yellow, length(str_subset(words,j)))}
  }
  
  if (i == words[1]) {yellows <- sum(yellow)} else {yellows <- c(yellows, sum(yellow))}
}

# Find how many letters each word matches with other words, in the right position (greens)

for (i in words){
 
  for (j in 1:5){
    if (j == 1) {green <- length(str_subset(str_sub(words,j,j),str_sub(i,j,j)))} 
    else {green <- c(green, length(str_subset(str_sub(words,j,j),str_sub(i,j,j))))}
  }
  
  if (i == words[1]) {greens <- sum(green)} else {greens <- c(greens, sum(green))}
}

# Arbitrarily add the two together and scale to make an index score

print(first.words <- tibble(word = words, yellows = yellows, greens = greens) %>% mutate(index = as.numeric(scale(yellows+greens))) %>% arrange(desc(index)))






