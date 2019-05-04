library(caret)

set.seed(258)

# Create training and test datasets
df_index <- createDataPartition(
	wdbc$diagnosis 
		, p = part_ratio
		, list = lst
)
train_df <-  wdbc[df_index, ]
head(train_df)
test_df <- wdbc[-df_index, ]
head(test_df)
