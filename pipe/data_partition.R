## library(caret)

# This script uses functions from caret package to create training and test datasets

dataPartition <- function(seed, part_ratio){
	set.seed(seed)
	df_index <- createDataPartition(wdbc$diagnosis, 
		p=part_ratio,
		list=FALSE
	)
	return(
		list(
			wdbc_train = wdbc[df_index, ]
			, wdbc_test = wdbc[-df_index, ] 
		)
	)
}
