setwd("C:/Users/manue/Documents/Universidad/Thesis/Other files")
getwd()

# Assuming your dataframe is named "my_data"
library(openxlsx)

# Read data from a TSV file
Sei_data <- read.table("sorted.Filtered.sequence_class_scores.tsv", sep = "\t", header = TRUE)

# Assuming your dataframe is named Sei_data
# Select columns from the 10th column onwards
df <- Sei_data[, 11:ncol(Sei_data)]

# Function to find extreme positive or negative value in a row
find_extreme <- function(row, col_names) {
  max_value <- max(row, na.rm = TRUE)
  min_value <- min(row, na.rm = TRUE)
  
  # Determine if extreme value is positive or negative
  if (!is.na(min_value) && abs(min_value) > max_value) {
    return(list(value = min_value, column = col_names[which.min(row)]))
  } else {
    return(list(value = max_value, column = col_names[which.max(row)]))
  }
}

# Apply the function to each row of the dataframe
extreme_values <- t(sapply(1:nrow(df), function(i) find_extreme(df[i,], names(df))))

# Convert matrix to data frame
df2 <- as.data.frame(extreme_values)
custom_headers <- c("Sequence class scores", "Sequence class")  # Custom headers
colnames(df2) <- custom_headers

# Extract columns 2-8 from df
subset_df <- Sei_data[, 2:8]

# Merge subset_df with df2
merged_df <- cbind(subset_df, df2)

# Save dataframe as an Excel file
write.xlsx(merged_df, "score_extraction2.xlsx")

