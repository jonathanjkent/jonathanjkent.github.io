library(tidyverse)
library(stringr)

# Download word list and limit to 5 letter words
# Word list seems to be very similar, but not exactly the same, as the one used by Wordle
download.file("http://www.gwicks.net/textlists/usa.zip", words <- tempfile())
words <- read_csv(words, col_types = cols()) %>% rename(word = "a") %>% filter(validUTF8(word)==T) %>% filter(str_length(word) == 5)


#### Play (more fun to check after playing, cheater)
# Between daily Wordles, you can test here: http://foldr.moe/hello-wordl/

# Create wordle function
wordle <- function(word, colors){
  
  if (str_length(word) != 5) {stop("Word must be 5 letters.")}
  if (str_length(colors) != 5) {stop("Must have 5 colors.")}
  if ((str_remove_all(str_remove_all(str_remove_all(colors,"y"),"g"),"x")) != "") {stop("Check colors: only y g & x are valid.")}
  
  ys <- str_which(unlist(str_split(colors,"")),"y")
  gs <- str_which(unlist(str_split(colors,"")),"g")
  xs <- str_which(unlist(str_split(colors,"")),"x")
  ygs <- c(c(str_sub(word,ys,ys)),c(str_sub(word,gs,gs)))
  
  if (length(ys) > 0) {
    for (i in ys){remain <- str_subset(remain,str_sub(word,i,i))}
    for (i in ys){remain <- remain[str_which(str_sub(remain,i,i),str_sub(word,i,i), negate = T)]}
  }
  
  if (length(gs) > 0) {
    for (i in gs){remain <- remain[str_which(str_sub(remain,i,i),str_sub(word,i,i), negate = F)]}
  }
  
  if (length(xs) > 0) {for (i in xs){
    if (!str_sub(word,i,i) %in% ygs) {remain <- str_subset(remain,str_sub(word,i,i), negate = T)}
    }
  }
  
  if (length(ygs[duplicated(ygs)])>0) {
    for (i in ygs[duplicated(ygs)]) {
      remain <- remain[str_length(str_remove_all(remain,i)) < 4]
    }
  }
  
  for (i in remain){
    letters <- unique(unlist(str_split(i,"")))
    for (j in letters) {if (j == letters[1]) {test <- length(str_subset(remain,j))} else {test <- c(test, length(str_subset(remain,j)))}}
    if (i == remain[1]) {tests <- sum(test)} else {tests <- c(tests, sum(test))}
  }
  
  print(tibble(word = remain, similarity = tests) %>% mutate(similarity = as.numeric(scale(similarity))) %>% arrange(desc(similarity)))
  
  return(remain)
}

# Run this line to start new game.
remain <- words$word  

# Run this to find remaining words after each guess. 
# Colors are y for yellow, g for green, x for grey.
# "Similarity" variable ranks possible guesses by how many letters (in any position) they have in common with other remaining words (z-score).
remain <- wordle("first","ygxxx")  


#### Find best first words (takes a little while, be patient)

words <- words %>% mutate(yellows = 0, greens = 0)

# Find how many letters each word matches with other words, in any position (yellows)
for (i in 1:nrow(words)){
  
  letters <- unique(unlist(str_split(words$word[i],"")))
  
  for (j in letters) {
    
    if (j == letters[1]) {yellow <- length(str_subset(words$word,j))} else {yellow <- c(yellow, length(str_subset(words$word,j)))}
  }
  
  words$yellows[i] <- sum(yellow)
}

# Find how many letters each word matches with other words, in the right position (greens)
for (i in 1:nrow(words)){
 
  for (j in 1:5){
    if (j == 1) {green <- length(str_subset(str_sub(words$word,j,j),str_sub(words$word[i],j,j)))} 
    else {green <- c(green, length(str_subset(str_sub(words$word,j,j),str_sub(words$word[i],j,j))))}
  }
  
  words$greens[i] <- sum(green)
}

# Arbitrarily add the two together and scale to make an index score
words$index <- as.numeric(scale(words$yellows+words$greens))

print(words %>% arrange(desc(index)))




