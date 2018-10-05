library(caret)

# Create training and test datasets

part_ratio <- 0.75 # Ratio of training : test data
n_repeats <- 10 # Number of times to reselect the training and test data
adds <- sample(10:1000, n_repeats)
seeds <- seq(10, 10000, length.out = n_repeats) + adds

partition_sets <- list()
for (i in 1:length(seeds)){
	set.seed(seeds[[i]])
	df_index <- createDataPartition(
		wdbc$diagnosis 
		, p = part_ratio
		, list = FALSE
	)
	part_set_name <- paste("part_set", i, sep = "")
	partition_sets[[part_set_name]] 	<- list(
		train = wdbc[df_index, ]
		, test = wdbc[-df_index, ]
	)
}
