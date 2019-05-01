# Function to create dfm of corpus

tokensClean <- function(corp, n){
    tokenized <- tokens(corp, what = "word", remove_numbers = TRUE, remove_punct = TRUE,
                        remove_symbols = TRUE, remove_separators = TRUE, remove_url = TRUE,
                        remove_hyphens = TRUE, remove_twitter = TRUE)
    tokenized <- tokens_remove(tokenized, profanityList)
    tokenized <- tokens_ngrams(tokenized, n, concatenator = " ")
    DFM <- dfm(tokenized)
    return(DFM)
}