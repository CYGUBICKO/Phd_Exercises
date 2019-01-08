#### ---- This script contains functions to compute CI using bootstrap

# 1. aucFuc: Computes auc.Input is a dataframe of predicted class probs and the test class (observed)

aucFuc <- function(df_pred){
	rocr_pred <- prediction(df_pred[,1]
   	, df_pred[,2]
  )
  rocr_est <- performance(rocr_pred
  , "auc"
  )
  rocr_est@y.values[[1]]
}

# 2. Bootstrap function. Takes in the above data and and number of replicates

aucBoot <- function(data, reps) {
  	resamples <- lapply(1:reps
		, function(i) data[sample(nrow(data), replace = T), ])
  	observed_auc <- aucFuc(data)
  	r_auc <- sapply(resamples, aucFuc)

  	# Calculate std eror (Assuming t-distribution)
  	std_error <- sd(r_auc)/sqrt(length(r_auc))
	# error <- qt(0.975, df = length(r_auc)-1) * std_error

	# Mike suggested quantiles
	quants <- as.vector(quantile(r_auc, c(0.025, 0.975)))
  
	# Compute confidence interval
  	est_df <- data.frame("2.5%" = quants[[1]] 
		, Est = observed_auc
   	, "97.5%" = quants[[2]]
  	)
	result <- list(
  		estimates = est_df
    	, resample_auc=r_auc
    	, std_err=std_error
    	, resamples=resamples
  )
  return(result)
}
