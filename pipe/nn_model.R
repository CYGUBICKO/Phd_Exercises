library(caret)
library(nnet)
library(ROCR)
library(dplyr)

# Fit Neural Networks model the the training data and test it on the test data

nn_fit_results <- list()
nn_prediction_results <- list()
nn_auc_results <- NULL 
nn_prop_malignant_results <- NULL 
for (i in 1:length(seeds)){	
	wdbc_train <- partition_sets[[i]]$train
	wdbc_test <- partition_sets[[i]]$test
	result_name <- paste("nn_fit_result_set", i, sep = "")
	nn_fit_results[[result_name]] <- train(diagnosis~.
		, wdbc_train
		, method = "nnet"
		, metric = "ROC"
		, preProc = c("center", "scale")
		, tuneLength = 10
		, trControl = model_control
		, trace = FALSE
	)
	# Predictions
	## We predict the classes on test data
	predicted_class_name <- paste("nn_predicted_class_set", i, sep = "")
	nn_prediction_results[[predicted_class_name]] <- predict(nn_fit_results[[result_name]]
  		, wdbc_test
	)
	# Predicted probabilities
	predicted_prob_name <- paste("nn_predicted_prob_set", i, sep = "") 
	nn_prediction_results[[predicted_prob_name]] <- predict(nn_fit_results[[result_name]]
  		, wdbc_test
		, type = "prob"
	)
	# Obtain the AUC metric
	nn_predicted_prob <- prediction(nn_prediction_results[[predicted_prob_name]][ ,2]
		, wdbc_test$diagnosis
	)
	nn_auc <- performance(nn_predicted_prob, "auc")
	nn_auc_results <- c(nn_auc_results, unlist(nn_auc@y.values ))
	# Calculate the proportion of M predicted
	nn_prop_malignant <- data.frame(pred_class = nn_prediction_results[[predicted_class_name]]) %>%
		count(pred_class) %>% 
		mutate(prop = n/sum(n)) %>% 
		filter(pred_class == "M") %>% 
		select(prop)
		nn_prop_malignant_results <- c(nn_prop_malignant_results, nn_prop_malignant$prop)
}
nn_prop_malignant_results 


