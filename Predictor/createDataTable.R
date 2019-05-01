# Function to create data.table through intermediary data.frame (due to memory issues)
createDT <- function(df) {
    dataTable <- data.table(feature = df$feature, Frequency = df$frequency, keep.rownames = NULL,
                            stringsAsFactors = FALSE)
    return(dataTable)
}