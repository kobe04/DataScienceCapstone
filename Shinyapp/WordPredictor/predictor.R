## Function to predict the next word
# library(data.table); library(stringr)
predictWord <- function(dataTable, inputWords, top10){
    inputWords <- gsub("[[:digit:]]+", "", inputWords)
    inputWords <- gsub("[[:punct:][:blank:]]+", " ", inputWords)
    inputWords <- str_split(str_trim(str_to_lower(inputWords)), " ") [[1]]
    wordCount <- length(inputWords)
    if (wordCount >= 4){
        entered <- paste(inputWords[wordCount-3], inputWords[wordCount-2], inputWords[wordCount-1],
                       inputWords[wordCount])
        prediction <- dataTable[source == entered,]
        if (nrow(prediction) == 3){
            return(c(prediction[1,predict], prediction[2,predict], prediction[3,predict]))
        }
        else if (nrow(prediction) == 2){
            return(c(prediction[1,predict], prediction[2,predict]))
        }
        else if (nrow(prediction) >= 1){
            return(prediction[1,predict])
        }
        entered <- paste(inputWords[wordCount-2], inputWords[wordCount-1], inputWords[wordCount])
        prediction <- dataTable[source == entered,]
        if (nrow(prediction) == 3){
            return(c(prediction[1,predict], prediction[2,predict], prediction[3,predict]))
        }
        else if (nrow(prediction) == 2){
            return(c(prediction[1,predict], prediction[2,predict]))
        }
        else if (nrow(prediction) >= 1){
            return(prediction[1,predict])
        }
        entered <- paste(inputWords[wordCount-1], inputWords[wordCount])
        prediction <- dataTable[source == entered,]
        if (nrow(prediction) == 3){
            return(c(prediction[1,predict], prediction[2,predict], prediction[3,predict]))
        }
        else if (nrow(prediction) == 2){
            return(c(prediction[1,predict], prediction[2,predict]))
        }
        else if (nrow(prediction) >= 1){
            return(prediction[1,predict])
        }
        entered <- paste(inputWords[wordCount])
        prediction <- dataTable[source == entered,]
        if (nrow(prediction) == 3){
            return(c(prediction[1,predict], prediction[2,predict], prediction[3,predict]))
        }
        else if (nrow(prediction) == 2){
            return(c(prediction[1,predict], prediction[2,predict]))
        }
        else if (nrow(prediction) >= 1){
            return(prediction[1,predict])
        }
        return(top10[round(runif(1,min = 1, max = 10))])
    }
    else if (wordCount == 3){
        entered <- paste(inputWords[wordCount-2], inputWords[wordCount-1], inputWords[wordCount])
        prediction <- dataTable[source == entered,]
        if (nrow(prediction) == 3){
            return(c(prediction[1,predict], prediction[2,predict], prediction[3,predict]))
        }
        else if (nrow(prediction) == 2){
            return(c(prediction[1,predict], prediction[2,predict]))
        }
        else if (nrow(prediction) >= 1){
            return(prediction[1,predict])
        }
        entered <- paste(inputWords[wordCount-1], inputWords[wordCount])
        prediction <- dataTable[source == entered,]
        if (nrow(prediction) == 3){
            return(c(prediction[1,predict], prediction[2,predict], prediction[3,predict]))
        }
        else if (nrow(prediction) == 2){
            return(c(prediction[1,predict], prediction[2,predict]))
        }
        else if (nrow(prediction) >= 1){
            return(prediction[1,predict])
        }
        entered <- paste(inputWords[wordCount])
        prediction <- dataTable[source == entered,]
        if (nrow(prediction) == 3){
            return(c(prediction[1,predict], prediction[2,predict], prediction[3,predict]))
        }
        else if (nrow(prediction) == 2){
            return(c(prediction[1,predict], prediction[2,predict]))
        }
        else if (nrow(prediction) >= 1){
            return(prediction[1,predict])
        }
        return(top10[round(runif(1,min = 1, max = 10))])
    }
    else if (wordCount == 2){
        entered <- paste(inputWords[wordCount-1], inputWords[wordCount])
        prediction <- dataTable[source == entered,]
        if (nrow(prediction) == 3){
            return(c(prediction[1,predict], prediction[2,predict], prediction[3,predict]))
        }
        else if (nrow(prediction) == 2){
            return(c(prediction[1,predict], prediction[2,predict]))
        }
        else if (nrow(prediction) >= 1){
            return(prediction[1,predict])
        }
        entered <- paste(inputWords[wordCount])
        prediction <- dataTable[source == entered,]
        if (nrow(prediction) == 3){
            return(c(prediction[1,predict], prediction[2,predict], prediction[3,predict]))
        }
        else if (nrow(prediction) == 2){
            return(c(prediction[1,predict], prediction[2,predict]))
        }
        else if (nrow(prediction) >= 1){
            return(prediction[1,predict])
        }
        return(top10[round(runif(1,min = 1, max = 10))])
    }
    else{
        entered <- paste(inputWords[wordCount])
        prediction <- dataTable[source == entered,]
        if (nrow(prediction) == 3){
            return(c(prediction[1,predict], prediction[2,predict], prediction[3,predict]))
        }
        else if (nrow(prediction) == 2){
            return(c(prediction[1,predict], prediction[2,predict]))
        }
        else if (nrow(prediction) >= 1){
            return(prediction[1,predict])
        }
        return(top10[round(runif(1,min = 1, max = 10))])
    }
    return(top10[round(runif(1,min = 1, max = 10))])
}