library(caret)
library(ROCR)
library(dplyr)
library(ranger)

# Fit Random Forests model the the training data and test it on the test data

rf_fit_results <- list()
rf_prediction_results <- list()
rf_auc_results <- NULL
rf_prop_malignant_results <- NULL 
for (i in 1:length(seeds)){	
	wdbc_train <- partition_sets[[i]]$train
	wdbc_test <- partition_sets[[i]]$test
	result_name <- paste("rf_fit_result_set", i, sep = "")
	rf_fit_results[[result_name]] <- train(diagnosis~.
		, wdbc_train
		, method = "ranger"
		, metric = "ROC"
		, preProc = c("center", "scale")
		, tuneLength = 10
		, trControl = model_control
	)
	# Predictions
	## We predict the classes on test data
	predicted_class_name <- paste("rf_predicted_class_set", i, sep = "")
	rf_prediction_results[[predicted_class_name]] <- predict(rf_fit_results[[result_name]]
  		, wdbc_test
	)
	# Predicted probabilities
	predicted_prob_name <- paste("rf_predicted_prob_set", i, sep = "") 
	rf_prediction_results[[predicted_prob_name]] <- predict(rf_fit_results[[result_name]]
  		, wdbc_test
		, type = "prob"
	)
	# Obtain the AUC metric
	rf_predicted_prob <- prediction(rf_prediction_results[[predicted_prob_name]][ ,2]
		, wdbc_test$diagnosis
	)
	rf_auc <- performance(rf_predicted_prob, "auc")
	rf_auc_results <- c(rf_auc_results, unlist(rf_auc@y.values ))
	# Calculate the proportion of M predicted
	rf_prop_malignant <- data.frame(pred_class = rf_prediction_results[[predicted_class_name]]) %>%
		count(pred_class) %>% 
		mutate(prop = n/sum(n)) %>% 
		filter(pred_class == "M") %>% 
		select(prop)
		rf_prop_malignant_results <- c(rf_prop_malignant_results, rf_prop_malignant$prop)
}
