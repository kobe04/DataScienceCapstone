# Function to create corpus from text-input
corpusCreate <- function(txt){
    txt <- char_tolower(txt)
    dataCorpus <- corpus(txt)
}